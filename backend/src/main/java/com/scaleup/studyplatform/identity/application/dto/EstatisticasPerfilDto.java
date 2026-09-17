package com.scaleup.studyplatform.identity.application.dto;

import java.util.List;

/** GET /api/usuarios/atual/perfil/estatisticas (TICKET-perfil-usuario.md, seção 7). */
public record EstatisticasPerfilDto(EstatisticasGeraisDto geral, List<EstatisticasDominioDto> porDominio) {
}
