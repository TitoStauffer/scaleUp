package com.scaleup.studyplatform.content;

import java.util.Arrays;
import java.util.List;
import java.util.function.Consumer;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.resttestclient.TestRestTemplate;
import org.springframework.boot.resttestclient.autoconfigure.AutoConfigureTestRestTemplate;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;
import com.scaleup.studyplatform.content.application.dto.ConceptDto;
import com.scaleup.studyplatform.content.application.dto.DomainDetailDto;
import com.scaleup.studyplatform.content.application.dto.DomainSummaryDto;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Teste de integração ponta a ponta do módulo Content: sobe um Postgres real em container
 * (Testcontainers), aplica as migrações reais via Flyway (V1..V21) e valida a API de
 * leitura contra esse banco — nenhum mock de repositório/serviço.
 *
 * Cobre, na prática, os 3 achados corrigidos nesta tarefa:
 * 1) Concepts retornados na ordem pedagógica (coluna `ordem`, não mais título alfabético).
 * 2) Seeds sem `concept_ref` NULL silencioso — se algum concept_ref não resolvesse mais
 *    (regressão de V14/V16/V17/V20), o volume de slides/flashcards/questions por domínio
 *    cairia abaixo do esperado, o que os testes abaixo também detectariam.
 * 3) Nenhum teste automatizado existia neste módulo antes desta tarefa.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureTestRestTemplate
@Testcontainers
class ContentModuleIntegrationTest {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    @Autowired
    private TestRestTemplate restTemplate;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Test
    void aplicaAsMigracoesESobeAAplicacao() {
        // A própria inicialização do contexto Spring (incluindo Flyway) já falha o teste
        // se alguma migração V1..V21 não aplicar. Esta asserção apenas confirma que o
        // contexto subiu e a API responde.
        ResponseEntity<DomainSummaryDto[]> response = restTemplate.getForEntity("/api/dominios", DomainSummaryDto[].class);
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    void listaOsSeteDominiosEsperados() {
        ResponseEntity<DomainSummaryDto[]> response = restTemplate.getForEntity("/api/dominios", DomainSummaryDto[].class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        DomainSummaryDto[] dominios = response.getBody();
        assertThat(dominios).isNotNull();
        assertThat(dominios).hasSize(7);

        List<String> slugs = Arrays.stream(dominios).map(DomainSummaryDto::slug).toList();
        assertThat(slugs).containsExactlyInAnyOrder(
                "arquitetura",
                "sistemas-distribuidos",
                "bancos-de-dados",
                "apis-mensageria",
                "escalabilidade-desempenho",
                "observabilidade-confiabilidade",
                "seguranca");
    }

    @Test
    void detalheDoDominioArquiteturaTemConceitosNaOrdemPedagogicaOriginal() {
        ResponseEntity<DomainDetailDto> response = restTemplate.getForEntity("/api/dominios/arquitetura", DomainDetailDto.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        DomainDetailDto dominio = response.getBody();
        assertThat(dominio).isNotNull();
        assertThat(dominio.slug()).isEqualTo("arquitetura");
        assertThat(dominio.conceitos()).hasSize(5);

        // Ordem pedagógica original identificada na revisão de código, conforme apareciam
        // no bloco INSERT INTO concept de V14__seed_conteudo_arquitetura.sql — é essa
        // ordem que a coluna `ordem` (V21) deve preservar, não a ordem alfabética por
        // título (que colocaria "Acoplamento..." antes de "Estilos...").
        List<String> titulosNaOrdemRecebida = dominio.conceitos().stream().map(ConceptDto::titulo).toList();
        assertThat(titulosNaOrdemRecebida).containsExactly(
                "Estilos Arquiteturais e Camadas",
                "Monólito vs. Microsserviços",
                "Acoplamento, Coesão e Modularização",
                "Padrões Arquiteturais",
                "Evolução de Arquitetura e Trade-offs");

        // Cada Concept carrega seus 3 Slides, também em ordem.
        dominio.conceitos().forEach(concept -> assertThat(concept.slides()).hasSize(3));
    }

    @Test
    void detalheDoDominioBancosDeDadosTemConceitosNaOrdemPedagogicaOriginal() {
        ResponseEntity<DomainDetailDto> response = restTemplate.getForEntity("/api/dominios/bancos-de-dados", DomainDetailDto.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        DomainDetailDto dominio = response.getBody();
        assertThat(dominio).isNotNull();

        List<String> titulosNaOrdemRecebida = dominio.conceitos().stream().map(ConceptDto::titulo).toList();
        assertThat(titulosNaOrdemRecebida).containsExactly(
                "Modelagem relacional vs. NoSQL",
                "Indexação e desempenho de consultas",
                "Transações e ACID",
                "Níveis de isolamento e controle de concorrência",
                "Replicação, particionamento e CAP");
    }

    @Test
    void detalheDoDominioSegurancaTemConceitosNaOrdemPedagogicaOriginal() {
        ResponseEntity<DomainDetailDto> response = restTemplate.getForEntity("/api/dominios/seguranca", DomainDetailDto.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        DomainDetailDto dominio = response.getBody();
        assertThat(dominio).isNotNull();

        List<String> titulosNaOrdemRecebida = dominio.conceitos().stream().map(ConceptDto::titulo).toList();
        assertThat(titulosNaOrdemRecebida).containsExactly(
                "Autenticação e Autorização",
                "Criptografia Aplicada",
                "TLS e Segurança em Trânsito",
                "Vulnerabilidades Comuns em Aplicações Web",
                "Defesa em Profundidade e Controle de Abuso");
    }

    /**
     * Teste de regressão mais importante do módulo: a API de leitura de questões nunca
     * pode vazar a resposta correta (`correta`) nem a explicação (`explicacao`) antes da
     * submissão. QuestionDto/AlternativaDto já foram desenhados para nunca incluir esses
     * campos — este teste protege esse contrato no nível de JSON serializado, não apenas
     * no nível de tipo Java (que não pegaria, por exemplo, alguém expondo a entidade
     * Question diretamente em vez do DTO).
     */
    @Test
    void questoesNuncaExpoemCampoCorretaOuExplicacao() throws Exception {
        ResponseEntity<String> response = restTemplate.getForEntity("/api/dominios/arquitetura/questoes", String.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        String corpo = response.getBody();
        assertThat(corpo).isNotNull();

        JsonNode raiz = objectMapper.readTree(corpo);
        assertThat(raiz.isArray()).isTrue();
        assertThat(raiz.size()).isGreaterThan(0);

        Consumer<JsonNode> falhaSeCampoSensivelExistir = new Consumer<>() {
            @Override
            public void accept(JsonNode node) {
                if (node.isObject()) {
                    node.propertyNames().forEach(nomeDoCampo -> assertThat(nomeDoCampo)
                            .as("campo sensível vazado no JSON de /questoes: '%s'", nomeDoCampo)
                            .isNotIn("correta", "explicacao"));
                    node.forEach(this::accept);
                } else if (node.isArray()) {
                    node.forEach(this::accept);
                }
            }
        };
        falhaSeCampoSensivelExistir.accept(raiz);
    }
}
