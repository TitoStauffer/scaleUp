---
name: engineering-mobile-development
description: Projete, desenvolva ou revise aplicações mobile em Flutter ou React Native, escolhendo a tecnologia e a arquitetura conforme requisitos de produto, integração nativa e operação. Use para apps iOS e Android; não fixe Flutter ou React Native sem avaliar o contexto.
---

# Desenvolvimento mobile

Comece pelos fluxos críticos, plataformas alvo, necessidades offline, integrações nativas, requisitos de desempenho, experiência esperada e capacidade do time. Escolha Flutter quando a consistência visual multiplataforma, um único runtime de UI ou o ecossistema Dart forem vantagens relevantes. Escolha React Native quando o time e o compartilhamento de conhecimento React/TypeScript, bibliotecas existentes ou integração com uma base React trouxerem vantagem concreta. Valide cedo integrações nativas que representem risco, independentemente da escolha.

## Arquitetura e ciclo de vida

Separe apresentação, estado e acesso a dados de modo que o fluxo possa ser testado sem dispositivo sempre que possível. Trate transições de ciclo de vida, conectividade intermitente, reinício do processo, notificações, deep links e permissões como estados normais do produto, não exceções improváveis.

Defina estratégia de cache, sincronização e conflito antes de oferecer edição offline. Faça operações de escrita idempotentes quando houver repetição após reconexão. Mantenha tokens, credenciais e dados sensíveis em armazenamento apropriado à plataforma; não os deixe em logs, preferências comuns ou bundles.

## Experiência e entrega

Respeite padrões de navegação, acessibilidade, área segura, teclado, tamanho de toque e permissões de cada plataforma. Meça crashes, lentidão, falhas de rede e funis críticos com telemetria que não exponha dados pessoais. Planeje assinatura, configuração por ambiente, distribuição, compatibilidade mínima e rollback antes de publicar.

Teste regras e estado fora da UI, fluxos críticos em emulador/dispositivo e integrações nativas reais quando aplicáveis. Não assuma que uma interface ou biblioteca tem comportamento idêntico em iOS e Android.
