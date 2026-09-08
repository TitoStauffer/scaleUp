package com.scaleup.studyplatform.assessment.domain;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = false)
public class StatusTentativaConverter implements AttributeConverter<StatusTentativa, String> {

    @Override
    public String convertToDatabaseColumn(StatusTentativa attribute) {
        return attribute == null ? null : attribute.getValor();
    }

    @Override
    public StatusTentativa convertToEntityAttribute(String dbData) {
        return dbData == null ? null : StatusTentativa.fromValor(dbData);
    }
}
