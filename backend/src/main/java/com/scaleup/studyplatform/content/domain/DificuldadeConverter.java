package com.scaleup.studyplatform.content.domain;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = false)
public class DificuldadeConverter implements AttributeConverter<Dificuldade, String> {

    @Override
    public String convertToDatabaseColumn(Dificuldade attribute) {
        return attribute == null ? null : attribute.getValor();
    }

    @Override
    public Dificuldade convertToEntityAttribute(String dbData) {
        return dbData == null ? null : Dificuldade.fromValor(dbData);
    }
}
