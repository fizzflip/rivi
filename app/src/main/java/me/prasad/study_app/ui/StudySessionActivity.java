package me.prasad.study_app.ui;

import android.animation.AnimatorInflater;
import android.animation.AnimatorSet;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.lifecycle.ViewModelProvider;

import com.google.android.material.button.MaterialButton;
import com.google.android.material.card.MaterialCardView;

import java.util.List;

import me.prasad.study_app.R;
import me.prasad.study_app.data.entity.Flashcard;
import me.prasad.study_app.data.entity.Subject;
import me.prasad.study_app.logic.SRSLogic;
import me.prasad.study_app.viewmodel.FlashcardViewModel;
import me.prasad.study_app.viewmodel.SubjectViewModel;

public class StudySessionActivity extends AppCompatActivity {

    public static final String EXTRA_SUBJECT_ID = "extra_subject_id";

    private FlashcardViewModel flashcardViewModel;
    private SubjectViewModel subjectViewModel;

    private TextView textSubjectTitle, textSessionProgress, textCardContent;
    private MaterialCardView cardFlashcard;
    private LinearLayout layoutGrading;
    private MaterialButton btnAgain, btnHard, btnGood, btnEasy;

    private List<Flashcard> sessionCards;
    private Subject currentSubject;
    private boolean isShowingAnswer = false;
    private AnimatorSet flipOut, flipIn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_study_session);

        int subjectId = getIntent().getIntExtra(EXTRA_SUBJECT_ID, -1);
        if (subjectId == -1) {
            finish();
            return;
        }

        initViews();
        setupViewModels(subjectId);
    }

    private void initViews() {
        textSubjectTitle = findViewById(R.id.text_subject_title);
        textSessionProgress = findViewById(R.id.text_session_progress);
        textCardContent = findViewById(R.id.text_card_content);
        cardFlashcard = findViewById(R.id.card_flashcard);
        layoutGrading = findViewById(R.id.layout_grading);

        btnAgain = findViewById(R.id.btn_again);
        btnHard = findViewById(R.id.btn_hard);
        btnGood = findViewById(R.id.btn_good);
        btnEasy = findViewById(R.id.btn_easy);

        cardFlashcard.setOnClickListener(v -> flipCard());

        btnAgain.setOnClickListener(v -> submitGrade(SRSLogic.Grade.AGAIN));
        btnHard.setOnClickListener(v -> submitGrade(SRSLogic.Grade.HARD));
        btnGood.setOnClickListener(v -> submitGrade(SRSLogic.Grade.GOOD));
        btnEasy.setOnClickListener(v -> submitGrade(SRSLogic.Grade.EASY));

        flipOut = (AnimatorSet) AnimatorInflater.loadAnimator(this, R.animator.card_flip_out);
        flipIn = (AnimatorSet) AnimatorInflater.loadAnimator(this, R.animator.card_flip_in);
    }

    private void setupViewModels(int subjectId) {
        subjectViewModel = new ViewModelProvider(this).get(SubjectViewModel.class);
        flashcardViewModel = new ViewModelProvider(this).get(FlashcardViewModel.class);

        subjectViewModel.getSubjectById(subjectId).observe(this, subject -> {
            if (subject != null) {
                currentSubject = subject;
                textSubjectTitle.setText(subject.getName().toUpperCase());
                flashcardViewModel.startSession(subject.getSubjectId(), subject.getExamDate());
            }
        });

        flashcardViewModel.getSessionCards().observe(this, cards -> {
            sessionCards = cards;
            updateUI();
        });

        flashcardViewModel.getCurrentIndex().observe(this, index -> {
            isShowingAnswer = false;
            updateUI();
        });

        flashcardViewModel.getIsSessionComplete().observe(this, isComplete -> {
            if (isComplete) {
                Intent intent = new Intent(this, SessionRecapActivity.class);
                if (sessionCards != null) {
                    intent.putExtra("mastered_count", sessionCards.size());
                }
                startActivity(intent);
                finish();
            }
        });
    }

    private void flipCard() {
        if (sessionCards == null || sessionCards.isEmpty()) return;

        flipOut.setTarget(cardFlashcard);
        flipIn.setTarget(cardFlashcard);

        flipOut.start();
        flipOut.addListener(new android.animation.AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(android.animation.Animator animation) {
                isShowingAnswer = !isShowingAnswer;
                updateUI();
                flipIn.start();
            }
        });
    }

    private void updateUI() {
        Integer index = flashcardViewModel.getCurrentIndex().getValue();
        if (sessionCards == null || index == null || index >= sessionCards.size()) {
            return;
        }

        Flashcard currentCard = sessionCards.get(index);
        textSessionProgress.setText(getString(R.string.session_progress_format, (index + 1), sessionCards.size()));

        if (isShowingAnswer) {
            textCardContent.setText(currentCard.getAnswer());
            layoutGrading.setVisibility(View.VISIBLE);
            findViewById(R.id.text_tap_to_flip).setVisibility(View.INVISIBLE);
        } else {
            textCardContent.setText(currentCard.getQuestion());
            layoutGrading.setVisibility(View.GONE);
            findViewById(R.id.text_tap_to_flip).setVisibility(View.VISIBLE);
        }
    }

    private void submitGrade(SRSLogic.Grade grade) {
        Integer index = flashcardViewModel.getCurrentIndex().getValue();
        if (sessionCards != null && index != null && index < sessionCards.size()) {
            flashcardViewModel.submitGrade(sessionCards.get(index), currentSubject, grade);
        }
    }
}
