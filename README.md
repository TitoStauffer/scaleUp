# ScaleUp

Plataforma de estudos com Slides, Flashcards e Quiz para preparação em entrevistas de System Design.

## Estrutura

- `backend/`: Java, Spring Boot e Maven.
- `frontend/`: React, TypeScript, Vite e npm.
- `docs/`: PRD, arquitetura e plano de implementação.
- `skills/` e `agents/`: práticas reutilizáveis para evolução do projeto.

## Primeiro vertical slice

O fluxo alvo é: selecionar domínio → estudar slides → revisar flashcards → responder quiz → atualizar pontuação e nível.

## Desenvolvimento local

Backend:

```powershell
cd backend
mvn spring-boot:run
```

Frontend:

```powershell
cd frontend
npm install
npm run dev
```
