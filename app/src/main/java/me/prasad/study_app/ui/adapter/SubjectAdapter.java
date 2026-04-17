package me.prasad.study_app.ui.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.ProgressBar;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.lifecycle.LifecycleOwner;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;
import androidx.recyclerview.widget.RecyclerView;

import java.util.concurrent.TimeUnit;

import me.prasad.study_app.R;
import me.prasad.study_app.data.entity.Subject;

import me.prasad.study_app.viewmodel.SubjectViewModel;

public class SubjectAdapter extends ListAdapter<Subject, SubjectAdapter.SubjectViewHolder> {

    private static final DiffUtil.ItemCallback<Subject> DIFF_CALLBACK = new DiffUtil.ItemCallback<Subject>() {
        @Override
        public boolean areItemsTheSame(@NonNull Subject oldItem, @NonNull Subject newItem) {
            return oldItem.getSubjectId() == newItem.getSubjectId();
        }

        @Override
        public boolean areContentsTheSame(@NonNull Subject oldItem, @NonNull Subject newItem) {
            return oldItem.getName().equals(newItem.getName()) &&
                    oldItem.getExamDate() == newItem.getExamDate() &&
                    oldItem.getCurrentStreak() == newItem.getCurrentStreak();
        }
    };

    private final SubjectViewModel viewModel;
    private final LifecycleOwner lifecycleOwner;
    private OnSubjectClickListener listener;

    public SubjectAdapter(SubjectViewModel viewModel, LifecycleOwner lifecycleOwner) {
        super(DIFF_CALLBACK);
        this.viewModel = viewModel;
        this.lifecycleOwner = lifecycleOwner;
    }

    @NonNull
    @Override
    public SubjectViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_subject, parent, false);
        return new SubjectViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull SubjectViewHolder holder, int position) {
        Subject subject = getItem(position);
        holder.bind(subject);
    }

    public void setOnSubjectClickListener(OnSubjectClickListener listener) {
        this.listener = listener;
    }

    public interface OnSubjectClickListener {
        void onSubjectClick(Subject subject);

        void onManageCardsClick(Subject subject);

        void onExportClick(Subject subject);
    }

    class SubjectViewHolder extends RecyclerView.ViewHolder {
        private final TextView nameText;
        private final TextView streakText;
        private final TextView cardsDueText;
        private final ProgressBar proximityProgress;
        private final ImageButton manageCardsButton;
        private final ImageButton exportButton;

        public SubjectViewHolder(@NonNull View itemView) {
            super(itemView);
            nameText = itemView.findViewById(R.id.text_subject_name);
            streakText = itemView.findViewById(R.id.text_streak);
            cardsDueText = itemView.findViewById(R.id.text_cards_due);
            proximityProgress = itemView.findViewById(R.id.progress_exam_proximity);
            manageCardsButton = itemView.findViewById(R.id.btn_manage_cards);
            exportButton = itemView.findViewById(R.id.btn_export);

            itemView.setOnClickListener(v -> {
                int position = getAdapterPosition();
                if (listener != null && position != RecyclerView.NO_POSITION) {
                    listener.onSubjectClick(getItem(position));
                }
            });

            manageCardsButton.setOnClickListener(v -> {
                int position = getAdapterPosition();
                if (listener != null && position != RecyclerView.NO_POSITION) {
                    listener.onManageCardsClick(getItem(position));
                }
            });

            exportButton.setOnClickListener(v -> {
                int position = getAdapterPosition();
                if (listener != null && position != RecyclerView.NO_POSITION) {
                    listener.onExportClick(getItem(position));
                }
            });
        }

        public void bind(Subject subject) {
            nameText.setText(subject.getName());
            streakText.setText(itemView.getContext().getString(R.string.streak_format, subject.getCurrentStreak()));

            // Bind the actual due count from the ViewModel
            viewModel.getDueCount(subject.getSubjectId()).observe(lifecycleOwner, count -> {
                int displayCount = Math.min(count != null ? count : 0, 5);
                cardsDueText.setText(itemView.getContext().getString(R.string.cards_due_format, displayCount));
            });

            // Calculate progress towards exam (simplified)
            long now = System.currentTimeMillis();
            long totalDuration = subject.getExamDate() - (now - TimeUnit.DAYS.toMillis(30)); // Assume 30 day window for progress
            long timePassed = now - (subject.getExamDate() - TimeUnit.DAYS.toMillis(30));

            if (totalDuration > 0) {
                int progress = (int) ((timePassed * 100) / totalDuration);
                proximityProgress.setProgress(Math.max(0, Math.min(100, progress)));
            } else {
                proximityProgress.setProgress(100);
            }
        }
    }
}
