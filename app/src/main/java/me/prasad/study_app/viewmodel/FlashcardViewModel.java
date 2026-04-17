package me.prasad.study_app.viewmodel;

import android.app.Application;

import androidx.annotation.NonNull;
import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;

import java.util.List;

import me.prasad.study_app.data.entity.Flashcard;
import me.prasad.study_app.data.entity.Subject;
import me.prasad.study_app.data.repository.RiviRepository;
import me.prasad.study_app.logic.SRSLogic;

public class FlashcardViewModel extends AndroidViewModel {

    private final RiviRepository repository;
    private final MutableLiveData<List<Flashcard>> sessionCards = new MutableLiveData<>();
    private final MutableLiveData<Integer> currentIndex = new MutableLiveData<>(0);
    private final MutableLiveData<Boolean> isSessionComplete = new MutableLiveData<>(false);

    public FlashcardViewModel(@NonNull Application application) {
        super(application);
        repository = new RiviRepository(application);
    }

    public void startSession(int subjectId, long examDate) {
        new Thread(() -> {
            List<Flashcard> cards;
            if (SRSLogic.isEmergencyCramMode(examDate)) {
                cards = repository.getAllCardsForCram(subjectId);
            } else {
                cards = repository.getSmartFiveCards(subjectId, System.currentTimeMillis());
            }
            sessionCards.postValue(cards);
            if (cards.isEmpty()) {
                isSessionComplete.postValue(true);
            }
        }).start();
    }

    public LiveData<List<Flashcard>> getFlashcardsForSubject(int subjectId) {
        return repository.getFlashcardsForSubject(subjectId);
    }

    public LiveData<List<Flashcard>> getSessionCards() {
        return sessionCards;
    }

    public LiveData<Integer> getCurrentIndex() {
        return currentIndex;
    }

    public LiveData<Boolean> getIsSessionComplete() {
        return isSessionComplete;
    }

    public void submitGrade(Flashcard card, Subject subject, SRSLogic.Grade grade) {
        SRSLogic.updateCard(card, subject, grade);
        repository.updateFlashcard(card);

        Integer current = currentIndex.getValue();
        List<Flashcard> cards = sessionCards.getValue();

        if (current != null && cards != null) {
            if (current + 1 < cards.size()) {
                currentIndex.setValue(current + 1);
            } else {
                isSessionComplete.setValue(true);
            }
        }
    }

    public void insertFlashcard(Flashcard card) {
        repository.insertFlashcard(card);
    }

    public void deleteFlashcard(Flashcard card) {
        repository.deleteFlashcard(card);
    }
}
