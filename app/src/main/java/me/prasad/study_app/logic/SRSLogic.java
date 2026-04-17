package me.prasad.study_app.logic;

import java.util.concurrent.TimeUnit;

import me.prasad.study_app.data.entity.Flashcard;
import me.prasad.study_app.data.entity.Subject;

/**
 * Implementation of the Spaced Repetition System (SRS) logic.
 * Uses a modified SM-2 algorithm with "Exam Date" awareness.
 */
public class SRSLogic {

    private static final float MIN_EASE_FACTOR = 1.3f;
    private static final long MS_IN_DAY = TimeUnit.DAYS.toMillis(1);

    /**
     * Updates the flashcard statistics based on the user's performance.
     *
     * @param card    The flashcard being graded.
     * @param subject The subject the flashcard belongs to (used for exam date).
     * @param grade   The quality of the response.
     */
    public static void updateCard(Flashcard card, Subject subject, Grade grade) {
        float easeFactor = card.getEaseFactor();
        int interval = card.getInterval();
        int q = grade.getValue();

        // 1. Calculate Ease Factor (SM-2 standard formula)
        // EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
        easeFactor = (float) (easeFactor + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02)));
        if (easeFactor < MIN_EASE_FACTOR) {
            easeFactor = MIN_EASE_FACTOR;
        }
        card.setEaseFactor(easeFactor);

        // 2. Calculate Interval
        if (q < 3) {
            // "Again" - Reset interval
            interval = 1;
        } else {
            if (interval == 0) {
                interval = 1;
            } else if (interval == 1) {
                interval = 6;
            } else {
                interval = Math.round(interval * easeFactor);
            }
        }

        // 3. Apply "Target-Date" Aggressiveness
        // If the exam is close, we compress the interval to ensure more frequent reviews.
        interval = applyExamAggressiveness(interval, subject.getExamDate());

        card.setInterval(interval);

        // 4. Set Next Review Date
        long nextReview = System.currentTimeMillis() + (interval * MS_IN_DAY);
        card.setNextReviewDate(nextReview);
    }

    /**
     * Reduces the interval as the exam date approaches.
     */
    private static int applyExamAggressiveness(int interval, long examDate) {
        long currentTime = System.currentTimeMillis();
        long timeUntilExam = examDate - currentTime;

        if (timeUntilExam <= 0) {
            return 1; // Exam is today or passed, daily review if studying.
        }

        long daysUntilExam = TimeUnit.MILLISECONDS.toDays(timeUntilExam);

        if (daysUntilExam <= 7) {
            // Within 1 week: Max interval is 2 days
            return Math.min(interval, 2);
        } else if (daysUntilExam <= 14) {
            // Within 2 weeks: Reduce interval by 50%
            return Math.max(1, interval / 2);
        } else if (daysUntilExam <= 30) {
            // Within 1 month: Reduce interval by 25%
            return Math.max(1, (int) (interval * 0.75));
        }

        return interval;
    }

    /**
     * Checks if the subject is in "Emergency Cram" mode (within 48 hours of exam).
     */
    public static boolean isEmergencyCramMode(long examDate) {
        long timeUntilExam = examDate - System.currentTimeMillis();
        return timeUntilExam > 0 && timeUntilExam <= (2 * MS_IN_DAY);
    }

    public enum Grade {
        AGAIN(0),  // Complete failure
        HARD(3),   // Correct response after a serious hesitation
        GOOD(4),   // Correct response after a hesitation
        EASY(5);   // Perfect response

        private final int value;

        Grade(int value) {
            this.value = value;
        }

        public int getValue() {
            return value;
        }
    }
}
