package me.prasad.study_app.data.entity;

import androidx.room.Entity;
import androidx.room.PrimaryKey;

/**
 * Represents a study subject in the Rivi app.
 * Each subject has a specific exam date and tracks the user's daily study streak.
 */
@Entity(tableName = "subjects")
public class Subject {

    @PrimaryKey(autoGenerate = true)
    private int subjectId;

    private String name;

    /**
     * UNIX timestamp for the exam date.
     * Used to calculate the aggressiveness of the SRS algorithm.
     */
    private long examDate;

    private int currentStreak;

    // Constructor
    public Subject(String name, long examDate, int currentStreak) {
        this.name = name;
        this.examDate = examDate;
        this.currentStreak = currentStreak;
    }

    // Getters and Setters
    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public long getExamDate() {
        return examDate;
    }

    public void setExamDate(long examDate) {
        this.examDate = examDate;
    }

    public int getCurrentStreak() {
        return currentStreak;
    }

    public void setCurrentStreak(int currentStreak) {
        this.currentStreak = currentStreak;
    }
}
