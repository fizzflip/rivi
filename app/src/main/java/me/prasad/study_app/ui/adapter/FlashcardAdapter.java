package me.prasad.study_app.ui.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;
import androidx.recyclerview.widget.RecyclerView;

import me.prasad.study_app.R;
import me.prasad.study_app.data.entity.Flashcard;

public class FlashcardAdapter extends ListAdapter<Flashcard, FlashcardAdapter.FlashcardViewHolder> {

    public FlashcardAdapter() {
        super(DIFF_CALLBACK);
    }

    private static final DiffUtil.ItemCallback<Flashcard> DIFF_CALLBACK = new DiffUtil.ItemCallback<Flashcard>() {
        @Override
        public boolean areItemsTheSame(@NonNull Flashcard oldItem, @NonNull Flashcard newItem) {
            return oldItem.getCardId() == newItem.getCardId();
        }

        @Override
        public boolean areContentsTheSame(@NonNull Flashcard oldItem, @NonNull Flashcard newItem) {
            return oldItem.getQuestion().equals(newItem.getQuestion()) &&
                    oldItem.getAnswer().equals(newItem.getAnswer());
        }
    };

    @NonNull
    @Override
    public FlashcardViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_flashcard, parent, false);
        return new FlashcardViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull FlashcardViewHolder holder, int position) {
        Flashcard card = getItem(position);
        holder.bind(card);
    }

    static class FlashcardViewHolder extends RecyclerView.ViewHolder {
        private final TextView questionText;
        private final TextView answerText;

        public FlashcardViewHolder(@NonNull View itemView) {
            super(itemView);
            questionText = itemView.findViewById(R.id.text_question);
            answerText = itemView.findViewById(R.id.text_answer);
        }

        public void bind(Flashcard card) {
            questionText.setText(card.getQuestion());
            answerText.setText(card.getAnswer());
        }
    }
}
