package me.prasad.study_app.data.entity;

import androidx.room.Entity;
import androidx.room.ForeignKey;
import androidx.room.Index;
import androidx.room.PrimaryKey;

/**
 * Represents a single flashcard within a subject.
 * Uses a foreign key to link back to the Subject entity.
 */
@Entity(
    tableName = "flashcards",
    foreignKeys = @ForeignKey(
        entity = Subject.class,
        parentColumns = "subjectId",
        childColumns = "subjectId",
        onDelete = ForeignKey.CASCADE
    ),
    indices = {@Index("subjectId")}
)
public class Flashcard {

    @PrimaryKey(autoGenerate = true)
    private int cardId;

    private int subjectId;

    private String question;

    private String answer;

    /**
     * UNIX timestamp for the next scheduled review.
     */
    private long nextReviewDate;

    /**
     * Current interval in days between reviews.
     */
    private int interval;

    /**
     * The difficulty factor (starting at 2.5) for the SM-2 algorithm.
     */
    private float easeFactor;

    // Constructor
    public Flashcard(int subjectId, String question, String answer, long nextReviewDate, int interval, float easeFactor) {
        this.subjectId = subjectId;
        this.question = question;
        this.answer = answer;
        this.nextReviewDate = nextReviewDate;
        this.interval = interval;
        this.easeFactor = easeFactor;
    }

    // Getters and Setters
    public int getCardId() {
        return cardId;
    }

    public void setCardId(int cardId) {
        this.cardId = cardId;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public long getNextReviewDate() {
        return nextReviewDate;
    }

    public void setNextReviewDate(long nextReviewDate) {
        this.nextReviewDate = nextReviewDate;
    }

    public int getInterval() {
        return interval;
    }

    public void setInterval(int interval) {
        this.interval = interval;
    }

    public float getEaseFactor() {
        return easeFactor;
    }

    public void setEaseFactor(float easeFactor) {
        this.easeFactor = easeFactor;
    }
}
