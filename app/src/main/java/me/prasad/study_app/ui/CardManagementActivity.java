package me.prasad.study_app.ui;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;

import me.prasad.study_app.R;
import me.prasad.study_app.data.entity.Flashcard;
import me.prasad.study_app.ui.adapter.FlashcardAdapter;
import me.prasad.study_app.viewmodel.FlashcardViewModel;

public class CardManagementActivity extends AppCompatActivity {

    public static final String EXTRA_SUBJECT_ID = "extra_subject_id";

    private FlashcardViewModel viewModel;
    private FlashcardAdapter adapter;
    private int subjectId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_card_management);

        subjectId = getIntent().getIntExtra(EXTRA_SUBJECT_ID, -1);
        if (subjectId == -1) {
            finish();
            return;
        }

        setupRecyclerView();

        viewModel = new ViewModelProvider(this).get(FlashcardViewModel.class);
        viewModel.getFlashcardsForSubject(subjectId).observe(this, cards -> adapter.submitList(cards));
    }

    private void setupRecyclerView() {
        RecyclerView recyclerView = findViewById(R.id.recycler_flashcards);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        adapter = new FlashcardAdapter();
        recyclerView.setAdapter(adapter);

        adapter.setOnCardDeleteListener(card -> new AlertDialog.Builder(this)
                .setTitle(R.string.delete_card)
                .setMessage("Are you sure you want to delete this card?")
                .setPositiveButton("Delete", (dialog, which) -> viewModel.deleteFlashcard(card))
                .setNegativeButton("Cancel", null)
                .show());

        View fab = findViewById(R.id.fab_add_card);
        if (fab != null) {
            fab.setOnClickListener(v -> showAddCardDialog());
        }
    }

    private void showAddCardDialog() {
        View view = LayoutInflater.from(this).inflate(R.layout.dialog_add_card, null);
        TextInputEditText questionInput = view.findViewById(R.id.edit_question);
        TextInputEditText answerInput = view.findViewById(R.id.edit_answer);
        MaterialButton btnSave = view.findViewById(R.id.btn_save);
        MaterialButton btnCancel = view.findViewById(R.id.btn_cancel);

        AlertDialog dialog = new AlertDialog.Builder(this)
                .setView(view)
                .create();

        btnSave.setOnClickListener(v -> {
            String question = questionInput.getText() != null ? questionInput.getText().toString().trim() : "";
            String answer = answerInput.getText() != null ? answerInput.getText().toString().trim() : "";

            if (question.isEmpty() || answer.isEmpty()) {
                Toast.makeText(this, "Please fill all fields", Toast.LENGTH_SHORT).show();
                return;
            }

            // New card with default SM-2 values
            Flashcard card = new Flashcard(subjectId, question, answer, System.currentTimeMillis(), 0, 2.5f);
            viewModel.insertFlashcard(card);
            dialog.dismiss();
        });

        btnCancel.setOnClickListener(v -> dialog.dismiss());

        dialog.show();
    }
}
