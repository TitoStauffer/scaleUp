---
name: devops-infrastructure-as-code
description: Modele e revise infraestrutura como código com mudanças revisáveis, estado controlado e operações seguras. Use para provisionamento, alteração ou padronização de recursos de infraestrutura.
---

# Infraestrutura como código

Declare infraestrutura de forma idempotente, modular apenas onde o reuso ou a fronteira operacional justificarem, e versionada junto com suas revisões. Evite alterações manuais persistentes que criem drift; quando forem inevitáveis, registre e reconcilie o estado.

## Mudanças

Antes de aplicar, revise o plano para identificar recriações, exclusões, alterações de acesso, exposição de rede, impacto em dados e custo. Separe recursos por ambiente e responsabilidade, com nomes, tags e ownership suficientes para auditoria e operação.

Proteja o estado da infraestrutura contra acesso concorrente, perda e exposição de segredos. Entradas sensíveis devem usar mecanismos seguros de configuração; mascaramento no console não substitui controle de acesso ao estado e aos arquivos gerados.

## Segurança operacional

Use privilégios mínimos para automação e mantenha ações destrutivas protegidas por revisão ou confirmação apropriada. Para recursos duráveis, defina retenção, backup, restauração e estratégia de substituição antes de aplicar uma mudança irreversível. Valide recursos criados com checagens proporcionais ao impacto, não apenas pela conclusão do comando.
