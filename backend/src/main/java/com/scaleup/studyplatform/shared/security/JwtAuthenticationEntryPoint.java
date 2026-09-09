package com.scaleup.studyplatform.shared.security;

import java.nio.charset.StandardCharsets;
import java.time.Instant;

import org.springframework.http.MediaType;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import com.scaleup.studyplatform.shared.ApiErrorResponse;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tools.jackson.databind.ObjectMapper;

/**
 * AC-10/AC-11: 401 uniforme para qualquer rota protegida sem token, com token malformado,
 * inválido ou expirado — nunca detalha qual dos casos ocorreu.
 */
@Component
public class JwtAuthenticationEntryPoint implements AuthenticationEntryPoint {

    private final ObjectMapper objectMapper;

    public JwtAuthenticationEntryPoint(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException)
            throws java.io.IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        // Sem isto, o container usa ISO-8859-1 por padrão para o Writer — acentos da
        // mensagem (ex. "não autenticada") saem corrompidos no JSON (mojibake), ao contrário
        // das respostas normais do GlobalExceptionHandler, que passam pelo
        // HttpMessageConverter do Spring MVC (já UTF-8 por padrão). Este entry point escreve
        // a resposta manualmente porque roda no filtro do Spring Security, antes do MVC.
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        ApiErrorResponse corpo = new ApiErrorResponse(Instant.now(), 401, "NAO_AUTENTICADO",
                "requisição não autenticada: informe um token válido no header Authorization", request.getRequestURI());
        response.getWriter().write(objectMapper.writeValueAsString(corpo));
    }
}
