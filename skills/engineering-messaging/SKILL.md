---
name: engineering-messaging
description: Projete, implemente ou revise mensageria assíncrona com contratos de eventos, processamento idempotente, recuperação de falhas e operação observável. Use para Kafka, RabbitMQ ou outros brokers; não escolha uma tecnologia sem requisitos que justifiquem a decisão.
---

# Engenharia de mensageria

Comece pelo propósito do fluxo: desacoplamento, processamento assíncrono, integração entre domínios, absorção de picos ou execução eventual. Defina produtor, consumidores, evento, comando ou fato de negócio, proprietário do contrato, dado mínimo necessário e semântica de entrega antes de configurar tópicos ou filas.

## Contratos e compatibilidade

Trate mensagens como APIs públicas. Inclua identificador estável, tipo, versão, horário e correlação quando necessários para o fluxo. Evolua payloads de forma compatível e mantenha consumidores tolerantes a campos desconhecidos ou versões suportadas. Evite publicar entidades internas ou dados sensíveis além do necessário.

Defina chaves de particionamento e expectativas de ordenação apenas onde a ordem for requisito de negócio; ordenação global normalmente impõe custo e não deve ser assumida. Documente quais garantias o broker e a aplicação fornecem — “exactly once” não deve ser alegado sem considerar efeitos externos.

## Processamento confiável

Projete consumidores idempotentes: mensagens podem ser duplicadas, atrasadas ou reprocessadas. Controle efeitos colaterais com chaves de idempotência, persistência de estado ou outro mecanismo adequado. Use o padrão outbox ou equivalente quando uma gravação de banco e a publicação precisarem manter consistência; não dependa de uma transação distribuída implícita.

Configure tentativas com limite, espera e classificação de falhas. Não repita indefinidamente erros permanentes. Encaminhe mensagens não processáveis a DLQ ou fluxo de falha com contexto para investigação e reprocessamento controlado; uma DLQ sem responsável ou processo de tratamento só oculta o problema.

## Operação e segurança

Monitore atraso de consumidores, taxa de processamento, falhas, retries, idade de mensagens e volume de DLQ. Propague IDs de correlação para logs e traces, sem registrar payloads sensíveis. Aplique autenticação, autorização por tópico/fila e menor privilégio para produtores, consumidores e ferramentas operacionais.

Teste contrato, duplicidade, indisponibilidade do broker, falha após efeito parcial, reprocessamento e compatibilidade entre versões. Mudanças que afetem retenção, particionamento, consumidores ou dados em produção exigem plano de rollout, rollback e autorização para o ambiente alvo.
