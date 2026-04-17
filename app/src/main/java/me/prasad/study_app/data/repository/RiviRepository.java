package me.prasad.study_app.data.repository;

import android.app.Application;

import androidx.lifecycle.LiveData;

import java.util.List;

import me.prasad.study_app.data.RiviDatabase;
import me.prasad.study_app.data.dao.RiviDao;
import me.prasad.study_app.data.entity.Flashcard;
import me.prasad.study_app.data.entity.Subject;

/**
 * Repository class that abstracts access to multiple data sources.
 * In this MVP, it handles the RiviDatabase.
 */
public class RiviRepository {

    private final RiviDao riviDao;
    private final LiveData<List<Subject>> allSubjects;

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
}
