package me.prasad.study_app.data.dao;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;
import androidx.room.Update;

import java.util.List;

import me.prasad.study_app.data.entity.Flashcard;
import me.prasad.study_app.data.entity.Subject;

@Dao
public interface RiviDao {

    // --- Subject Operations ---

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    long insertSubject(Subject subject);

    @Update
    void updateSubject(Subject subject);

    @Delete
    void deleteSubject(Subject subject);

    @Query("SELECT * FROM subjects ORDER BY name ASC")
    LiveData<List<Subject>> getAllSubjects();

    @Query("SELECT * FROM subjects WHERE subjectId = :subjectId")
    LiveData<Subject> getSubjectById(int subjectId);

    @Query("SELECT * FROM subjects WHERE subjectId = :subjectId")
    Subject getSubjectByIdSync(int subjectId);

    @Query("SELECT COUNT(*) FROM flashcards WHERE subjectId = :subjectId AND nextReviewDate <= :todayTimestamp")
    LiveData<Integer> getDueCountForSubject(int subjectId, long todayTimestamp);

    // --- Flashcard Operations ---

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    void insertFlashcard(Flashcard flashcard);

    @Update
    void updateFlashcard(Flashcard flashcard);

    @Delete
    void deleteFlashcard(Flashcard flashcard);

    @Query("SELECT * FROM flashcards WHERE subjectId = :subjectId")
    LiveData<List<Flashcard>> getFlashcardsForSubject(int subjectId);

    /**
     * The "Smart 5" Query:
     * Fetches up to 5 cards for a specific subject that are due for review (nextReviewDate <= today).
     * Cards are ordered by nextReviewDate to prioritize those most overdue.
     *
     * @param subjectId      The ID of the subject.
     * @param todayTimestamp The current UNIX timestamp (at the start of the day).
     * @return A list of 5 flashcards due for review.
     */
    @Query("SELECT * FROM flashcards " +
            "WHERE subjectId = :subjectId AND nextReviewDate <= :todayTimestamp " +
            "ORDER BY nextReviewDate ASC " +
            "LIMIT 5")
    List<Flashcard> getSmartFiveCards(int subjectId, long todayTimestamp);

    /**
     * Cram Mode Query:
     * Fetches ALL cards for a subject regardless of the 5-card limit or due date.
     * Used when the exam date is within 48 hours.
     */
    @Query("SELECT * FROM flashcards WHERE subjectId = :subjectId")
    List<Flashcard> getAllCardsForCram(int subjectId);
}
