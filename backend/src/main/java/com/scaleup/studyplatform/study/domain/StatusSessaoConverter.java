package com.scaleup.studyplatform.study.domain;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = false)
public class StatusSessaoConverter implements AttributeConverter<StatusSessao, String> {

    @Override
    public String convertToDatabaseColumn(StatusSessao attribute) {
        return attribute == null ? null : attribute.getValor();
    }

    @Override
    public StatusSessao convertToEntityAttribute(String dbData) {
        return dbData == null ? null : StatusSessao.fromValor(dbData);
    }
}
