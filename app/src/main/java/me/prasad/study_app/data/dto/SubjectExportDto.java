package me.prasad.study_app.data.dto;

import java.util.List;

public class SubjectExportDto {
    public String subjectName;
    public List<FlashcardDto> flashcards;

    public SubjectExportDto(String subjectName, List<FlashcardDto> flashcards) {
        this.subjectName = subjectName;
        this.flashcards = flashcards;
    }
}
