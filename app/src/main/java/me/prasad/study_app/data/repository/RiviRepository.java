package me.prasad.study_app.data.repository;

import android.app.Application;

import androidx.lifecycle.LiveData;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;
import me.prasad.study_app.data.RiviDatabase;
import me.prasad.study_app.data.dao.RiviDao;
import me.prasad.study_app.data.dto.FlashcardDto;
import me.prasad.study_app.data.dto.SubjectExportDto;
import me.prasad.study_app.data.entity.Flashcard;
import me.prasad.study_app.data.entity.Subject;

/**
 * Repository class that abstracts access to multiple data sources.
 * In this MVP, it handles the RiviDatabase.
 */
public class RiviRepository {

    private final RiviDao riviDao;
    private final LiveData<List<Subject>> allSubjects;
    private final Gson gson = new Gson();

    public RiviRepository(Application application) {
        RiviDatabase db = RiviDatabase.getDatabase(application);
        riviDao = db.riviDao();
        allSubjects = riviDao.getAllSubjects();
    }

    // --- Subject Operations ---

    public LiveData<List<Subject>> getAllSubjects() {
        return allSubjects;
    }

    public LiveData<Subject> getSubjectById(int subjectId) {
        return riviDao.getSubjectById(subjectId);
    }

    public LiveData<Integer> getDueCountForSubject(int subjectId, long todayTimestamp) {
        return riviDao.getDueCountForSubject(subjectId, todayTimestamp);
    }

    public void insertSubject(Subject subject) {
        RiviDatabase.databaseWriteExecutor.execute(() -> {
            riviDao.insertSubject(subject);
        });
    }

    public void updateSubject(Subject subject) {
        RiviDatabase.databaseWriteExecutor.execute(() -> {
            riviDao.updateSubject(subject);
        });
    }

    public void deleteSubject(Subject subject) {
        RiviDatabase.databaseWriteExecutor.execute(() -> {
            riviDao.deleteSubject(subject);
        });
    }

    // --- Flashcard Operations ---

    public LiveData<List<Flashcard>> getFlashcardsForSubject(int subjectId) {
        return riviDao.getFlashcardsForSubject(subjectId);
    }

    public void insertFlashcard(Flashcard flashcard) {
        RiviDatabase.databaseWriteExecutor.execute(() -> {
            riviDao.insertFlashcard(flashcard);
        });
    }

    public void updateFlashcard(Flashcard flashcard) {
        RiviDatabase.databaseWriteExecutor.execute(() -> {
            riviDao.updateFlashcard(flashcard);
        });
    }

    public void deleteFlashcard(Flashcard flashcard) {
        RiviDatabase.databaseWriteExecutor.execute(() -> {
            riviDao.deleteFlashcard(flashcard);
        });
    }

    /**
     * Fetches the "Smart 5" cards.
     * Note: This is synchronous/blocking, should be called from a background thread or via a custom implementation.
     */
    public List<Flashcard> getSmartFiveCards(int subjectId, long todayTimestamp) {
        return riviDao.getSmartFiveCards(subjectId, todayTimestamp);
    }

    public List<Flashcard> getAllCardsForCram(int subjectId) {
        return riviDao.getAllCardsForCram(subjectId);
    }

    // --- Export / Import ---

    public void exportSubject(int subjectId, OutputStream outputStream) {
        RiviDatabase.databaseWriteExecutor.execute(() -> {
            try (OutputStream os = outputStream;
                 OutputStreamWriter writer = new OutputStreamWriter(os, StandardCharsets.UTF_8)) {
                Subject subject = riviDao.getSubjectByIdSync(subjectId);
                List<Flashcard> cards = riviDao.getAllCardsForCram(subjectId);

                List<FlashcardDto> dtos = new ArrayList<>();
                for (Flashcard card : cards) {
                    dtos.add(new FlashcardDto(card.getQuestion(), card.getAnswer()));
                }

                SubjectExportDto exportDto = new SubjectExportDto(subject.getName(), dtos);
                String json = gson.toJson(exportDto);
                writer.write(json);
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }

    public void importSubject(InputStream inputStream, Runnable onComplete) {
        RiviDatabase.databaseWriteExecutor.execute(() -> {
            try (InputStream is = inputStream;
                 InputStreamReader reader = new InputStreamReader(is, StandardCharsets.UTF_8)) {
                SubjectExportDto importDto = gson.fromJson(reader, SubjectExportDto.class);
                if (importDto != null) {
                    Subject subject = new Subject(importDto.subjectName, System.currentTimeMillis() + 604800000L, 0);
                    long subjectId = riviDao.insertSubject(subject);

                    for (FlashcardDto cardDto : importDto.flashcards) {
                        Flashcard card = new Flashcard((int) subjectId, cardDto.question, cardDto.answer, System.currentTimeMillis(), 0, 2.5f);
                        riviDao.insertFlashcard(card);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (onComplete != null) onComplete.run();
            }
        });
    }
}
