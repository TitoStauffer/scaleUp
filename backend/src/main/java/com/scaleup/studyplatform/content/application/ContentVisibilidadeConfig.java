package com.scaleup.studyplatform.content.application;

import java.util.EnumSet;
import java.util.Set;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.scaleup.studyplatform.content.domain.StatusRevisao;

/**
 * Controla se a API de leitura serve conteúdo com status_revisao = 'rascunho' além de
 * 'revisado_aprovado'. Decisão do Tito: por enquanto (fase de desenvolvimento, sem revisão
 * humana feita ainda), servir também rascunho — propriedade `content.incluir-rascunho`,
 * default true em dev. DEVE ser desligada (false) antes de expor a API a usuários reais em
 * produção, quando houver conteúdo de fato revisado.
 */
@Component
public class ContentVisibilidadeConfig {

    private final boolean incluirRascunho;

    public ContentVisibilidadeConfig(@Value("${content.incluir-rascunho:true}") boolean incluirRascunho) {
        this.incluirRascunho = incluirRascunho;
    }

    public boolean isIncluirRascunho() {
        return incluirRascunho;
    }

    public Set<StatusRevisao> statusPermitidos() {
        return incluirRascunho
                ? EnumSet.of(StatusRevisao.RASCUNHO, StatusRevisao.REVISADO_APROVADO)
                : EnumSet.of(StatusRevisao.REVISADO_APROVADO);
    }
}
