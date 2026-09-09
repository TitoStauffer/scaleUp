package com.scaleup.studyplatform.shared.security;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import com.scaleup.studyplatform.identity.application.TokenJwtInvalidoException;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Lê o header {@code Authorization: Bearer <jwt>}, valida o token e popula o
 * {@link SecurityContextHolder} com o id do usuário como principal — substituindo o mecanismo
 * anterior de {@code CurrentUserProvider} resolver sempre o mesmo registro fixo.
 *
 * Se o header estiver ausente, malformado ou o token for inválido/expirado, o filtro
 * simplesmente NÃO autentica a requisição (não lança exceção aqui) — quem decide se isso é um
 * problema é o {@code SecurityConfig} (rota pública vs. protegida). Isso garante o 401
 * uniforme do AC-11 sem distinguir "sem token" de "token inválido": em ambos os casos a
 * requisição chega não-autenticada a uma rota protegida e é rejeitada do mesmo jeito pelo
 * {@link JwtAuthenticationEntryPoint}.
 *
 * Não é {@code @Component}: é instanciado explicitamente por {@link SecurityConfig} e
 * registrado só na cadeia de filtros do Spring Security. Isso evita que testes de fatia
 * (`@WebMvcTest`), que descobrem beans do tipo {@code Filter} automaticamente mas não
 * carregam o restante do contexto, tentem instanciá-lo sem o {@link JwtService} disponível.
 */
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private static final String PREFIXO_BEARER = "Bearer ";

    private final JwtService jwtService;

    public JwtAuthenticationFilter(JwtService jwtService) {
        this.jwtService = jwtService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String header = request.getHeader("Authorization");
        if (header != null && header.startsWith(PREFIXO_BEARER)) {
            String token = header.substring(PREFIXO_BEARER.length());
            try {
                UUID userId = jwtService.validarEExtrairUserId(token);
                var authentication = new UsernamePasswordAuthenticationToken(userId, null,
                        List.of(new SimpleGrantedAuthority("ROLE_USER")));
                SecurityContextHolder.getContext().setAuthentication(authentication);
            } catch (TokenJwtInvalidoException e) {
                SecurityContextHolder.clearContext();
            }
        }
        filterChain.doFilter(request, response);
    }
}
