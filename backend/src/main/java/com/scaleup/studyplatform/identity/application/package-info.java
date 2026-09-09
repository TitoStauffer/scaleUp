/**
 * Módulo Identity — camada de aplicação. Cadastro, confirmação, reenvio de token e login
 * (TICKET-autenticacao.md) convivem aqui com a resolução do usuário autenticado da
 * requisição ({@link com.scaleup.studyplatform.identity.application.CurrentUserProvider},
 * usado internamente por Study/Assessment/Progress) e sua exposição ao cliente
 * ({@link com.scaleup.studyplatform.identity.application.ConsultarUsuarioAtualService}).
 * Ver docs/architecture/implementation-plan-backend-infra.md, secao 1.
 */
package com.scaleup.studyplatform.identity.application;
