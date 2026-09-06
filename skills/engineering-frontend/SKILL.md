---
name: engineering-frontend
description: Desenvolva ou revise interfaces web e seus fluxos de estado, dados e acessibilidade com foco em comportamento confiável para usuários. Use para mudanças de frontend; não use para decisões de identidade visual sem requisitos de produto ou design.
---

# Engenharia de frontend

Implemente o fluxo do usuário e os estados que ele realmente encontrará: carregamento, ausência de dados, sucesso, erro, indisponibilidade parcial e permissões insuficientes. Não esconda falhas de integração atrás de estados genéricos que impeçam a pessoa de agir ou entender o próximo passo.

## Estado e integração

Defina uma fonte clara para cada estado e evite duplicar dados remotos em vários locais sem uma estratégia de invalidação. Trate respostas assíncronas fora de ordem, cancelamento e repetição de ação quando puderem alterar o resultado exibido. Consuma contratos de API de modo defensivo e mostre erros sem expor detalhes internos.

## Acessibilidade e qualidade

Prefira elementos semânticos e interações operáveis por teclado. Para componentes customizados, preserve foco, nome acessível, estados e feedback apropriados. Valide formulários de forma que a correção seja compreensível e que a mensagem seja percebida por tecnologias assistivas.

Verifique fluxos críticos em dimensões e navegadores relevantes ao projeto, e cubra com testes o comportamento observável, não a estrutura interna dos componentes. Evite otimizações de renderização ou abstrações de componentes sem evidência de necessidade.
