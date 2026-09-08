package com.scaleup.studyplatform.content.domain;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = false)
public class StatusRevisaoConverter implements AttributeConverter<StatusRevisao, String> {

    @Override
    public String convertToDatabaseColumn(StatusRevisao attribute) {
        return attribute == null ? null : attribute.getValor();
    }

    @Override
    public StatusRevisao convertToEntityAttribute(String dbData) {
        return dbData == null ? null : StatusRevisao.fromValor(dbData);
    }
}
