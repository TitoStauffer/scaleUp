package com.scaleup.studyplatform.identity.domain;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = false)
public class StatusContaConverter implements AttributeConverter<StatusConta, String> {

    @Override
    public String convertToDatabaseColumn(StatusConta attribute) {
        return attribute == null ? null : attribute.getValor();
    }

    @Override
    public StatusConta convertToEntityAttribute(String dbData) {
        return dbData == null ? null : StatusConta.fromValor(dbData);
    }
}
