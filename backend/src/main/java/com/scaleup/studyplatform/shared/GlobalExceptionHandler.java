package com.scaleup.studyplatform.shared;

import java.time.Instant;
import java.util.stream.Collectors;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.multipart.MaxUploadSizeExceededException;

import jakarta.servlet.http.HttpServletRequest;

import com.scaleup.studyplatform.identity.application.ArquivoMuitoGrandeException;
import com.scaleup.studyplatform.identity.application.ContaNaoConfirmadaException;
import com.scaleup.studyplatform.identity.application.CredenciaisInvalidasException;
import com.scaleup.studyplatform.identity.application.EmailJaCadastradoAtivoException;
import com.scaleup.studyplatform.identity.application.EmailJaCadastradoPendenteException;
import com.scaleup.studyplatform.identity.application.RateLimitExcedidoException;
import com.scaleup.studyplatform.identity.application.SenhaAtualIncorretaException;
import com.scaleup.studyplatform.identity.application.TipoArquivoNaoSuportadoException;
import com.scaleup.studyplatform.identity.application.TokenExpiradoException;
import com.scaleup.studyplatform.identity.application.TokenInvalidoException;
import com.scaleup.studyplatform.identity.application.TokenRecuperacaoInvalidoException;

/**
 * Tratamento de erro HTTP comum a todos os módulos (shared, conforme
 * docs/architecture/implementation-plan-backend-infra.md, seção 1).
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(RecursoNaoEncontradoException.class)
    public ResponseEntity<ApiErrorResponse> handleRecursoNaoEncontrado(RecursoNaoEncontradoException ex,
            HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(new ApiErrorResponse(Instant.now(), 404, "RECURSO_NAO_ENCONTRADO", ex.getMessage(),
                        request.getRequestURI()));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ApiErrorResponse> handleIllegalArgument(IllegalArgumentException ex,
            HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(new ApiErrorResponse(Instant.now(), 400, "REQUISICAO_INVALIDA", ex.getMessage(),
                        request.getRequestURI()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiErrorResponse> handleValidacaoDeBean(MethodArgumentNotValidException ex,
            HttpServletRequest request) {
        String mensagem = ex.getBindingResult().getFieldErrors().stream()
                .map(erro -> erro.getField() + ": " + erro.getDefaultMessage())
                .collect(Collectors.joining("; "));
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(new ApiErrorResponse(Instant.now(), 400, "REQUISICAO_INVALIDA", mensagem,
                        request.getRequestURI()));
    }

    @ExceptionHandler(EstadoInvalidoException.class)
    public ResponseEntity<ApiErrorResponse> handleEstadoInvalido(EstadoInvalidoException ex,
            HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.CONFLICT)
                .body(new ApiErrorResponse(Instant.now(), 409, "ESTADO_INVALIDO", ex.getMessage(),
                        request.getRequestURI()));
    }

    // ---- TICKET-autenticacao.md ----

    @ExceptionHandler(CredenciaisInvalidasException.class)
    public ResponseEntity<ApiErrorResponse> handleCredenciaisInvalidas(CredenciaisInvalidasException ex,
            HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new ApiErrorResponse(Instant.now(), 401, "CREDENCIAIS_INVALIDAS", ex.getMessage(),
                        request.getRequestURI()));
    }

    @ExceptionHandler(ContaNaoConfirmadaException.class)
    public ResponseEntity<ApiErrorResponse> handleContaNaoConfirmada(ContaNaoConfirmadaException ex,
            HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .body(new ApiErrorResponse(Instant.now(), 403, "CONTA_NAO_CONFIRMADA", ex.getMessage(),
                        request.getRequestURI()));
    }

    @ExceptionHandler(TokenInvalidoException.class)
    public ResponseEntity<ApiErrorResponse> handleTokenInvalido(TokenInvalidoException ex, HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(new ApiErrorResponse(Instant.now(), 400, "TOKEN_INVALIDO", ex.getMessage(),
                        request.getRequestURI()));
    }

    @ExceptionHandler(TokenExpiradoException.class)
    public ResponseEntity<ApiErrorResponse> handleTokenExpirado(TokenExpiradoException ex, HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(new ApiErrorResponse(Instant.now(), 400, "TOKEN_EXPIRADO", ex.getMessage(),
                        request.getRequestURI()));
    }

    // ---- TICKET-cadastro-email-duplicado-visivel.md ----

    @ExceptionHandler(EmailJaCadastradoAtivoException.class)
    public ResponseEntity<ApiErrorResponse> handleEmailJaCadastradoAtivo(EmailJaCadastradoAtivoException ex,
            HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.CONFLICT)
                .body(new ApiErrorResponse(Instant.now(), 409, "EMAIL_JA_CADASTRADO_ATIVO", ex.getMessage(),
                        request.getRequestURI()));
    }

    @ExceptionHandler(EmailJaCadastradoPendenteException.class)
    public ResponseEntity<ApiErrorResponse> handleEmailJaCadastradoPendente(EmailJaCadastradoPendenteException ex,
            HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.CONFLICT)
                .body(new ApiErrorResponse(Instant.now(), 409, "EMAIL_JA_CADASTRADO_PENDENTE", ex.getMessage(),
                        request.getRequestURI()));
    }

    // ---- TICKET-alterar-senha.md ----

    @ExceptionHandler(SenhaAtualIncorretaException.class)
    public ResponseEntity<ApiErrorResponse> handleSenhaAtualIncorreta(SenhaAtualIncorretaException ex,
            HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new ApiErrorResponse(Instant.now(), 401, "SENHA_ATUAL_INCORRETA", ex.getMessage(),
                        request.getRequestURI()));
    }

    // ---- TICKET-esqueci-minha-senha.md ----

    @ExceptionHandler(TokenRecuperacaoInvalidoException.class)
    public ResponseEntity<ApiErrorResponse> handleTokenRecuperacaoInvalido(TokenRecuperacaoInvalidoException ex,
            HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(new ApiErrorResponse(Instant.now(), 400, "TOKEN_RECUPERACAO_INVALIDO", ex.getMessage(),
                        request.getRequestURI()));
    }

    // ---- TICKET-perfil-usuario.md ----

    @ExceptionHandler(ArquivoMuitoGrandeException.class)
    public ResponseEntity<ApiErrorResponse> handleArquivoMuitoGrande(ArquivoMuitoGrandeException ex,
            HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(new ApiErrorResponse(Instant.now(), 400, "ARQUIVO_MUITO_GRANDE", ex.getMessage(),
                        request.getRequestURI()));
    }

    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ResponseEntity<ApiErrorResponse> handleMaxUploadSizeExceeded(MaxUploadSizeExceededException ex,
            HttpServletRequest request) {
        // Rede de segurança do limite configurado em spring.servlet.multipart.max-file-size
        // (application.yml) — a validação de negócio (2MB, ArquivoMuitoGrandeException) já
        // cobre o caso esperado; este handler só evita a página de erro default do Spring
        // para requisições anormalmente grandes que nem chegam ao service.
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(new ApiErrorResponse(Instant.now(), 400, "ARQUIVO_MUITO_GRANDE", "arquivo excede o limite de 2MB",
                        request.getRequestURI()));
    }

    @ExceptionHandler(TipoArquivoNaoSuportadoException.class)
    public ResponseEntity<ApiErrorResponse> handleTipoArquivoNaoSuportado(TipoArquivoNaoSuportadoException ex,
            HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(new ApiErrorResponse(Instant.now(), 400, "TIPO_ARQUIVO_NAO_SUPORTADO", ex.getMessage(),
                        request.getRequestURI()));
    }

    @ExceptionHandler(RateLimitExcedidoException.class)
    public ResponseEntity<ApiErrorResponse> handleRateLimitExcedido(RateLimitExcedidoException ex,
            HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS)
                .body(new ApiErrorResponse(Instant.now(), 429, "RATE_LIMIT_EXCEDIDO", ex.getMessage(),
                        request.getRequestURI()));
    }
}
