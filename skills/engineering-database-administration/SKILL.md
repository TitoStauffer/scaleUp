---
name: engineering-database-administration
description: Planeje, execute ou revise mudanças de esquema, desempenho, confiabilidade e acesso a bancos de dados. Use para migrações, consultas críticas, permissões, capacidade e operação de dados persistidos.
---

# Administração de banco de dados

Trate o banco como sistema compartilhado e estado durável. Antes de mudar esquema ou consulta crítica, identifique volume, padrões de acesso, janelas de manutenção, consumidores e impacto de bloqueios. Não presuma que um banco, motor ou estratégia de índice específica existe sem confirmar.

## Esquema e migrações

Prefira migrações pequenas, versionadas e revisáveis. Para mudanças incompatíveis, use expansão, migração de consumidores/dados e contração posterior quando o sistema exigir disponibilidade contínua. Avalie dados legados, valores nulos, duplicidade, integridade referencial e tempo de execução antes de aplicar uma transformação.

Tenha backup restaurável ou outra estratégia de recuperação proporcional ao risco. Descreva como validar a migração e como interromper ou reverter com segurança; rollback de esquema nem sempre é seguro depois que dados novos foram gravados.

## Desempenho e segurança

Meça planos de execução e comportamento sob carga representativa antes de concluir que um índice ou reescrita resolveu um problema. Considere custo de escrita, seletividade, cardinalidade e crescimento futuro. Aplique menor privilégio para identidades de aplicação e operação; segredos, dumps e dados de produção não devem aparecer em código, logs ou ambientes não autorizados.

Monitore capacidade, latência, erros, conexões, replicação e saúde de backup conforme o banco permitir. Trate alterações em produção como operações com critério explícito de sucesso e parada.
