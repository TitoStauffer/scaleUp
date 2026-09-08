package com.scaleup.studyplatform.study.domain;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = false)
public class ResultadoAutoavaliacaoConverter implements AttributeConverter<ResultadoAutoavaliacao, String> {

    @Override
    public String convertToDatabaseColumn(ResultadoAutoavaliacao attribute) {
        return attribute == null ? null : attribute.getValor();
    }

    @Override
    public ResultadoAutoavaliacao convertToEntityAttribute(String dbData) {
        return dbData == null ? null : ResultadoAutoavaliacao.fromValor(dbData);
    }
}
