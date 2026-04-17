package me.prasad.study_app;

import android.app.DatePickerDialog;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.animation.AnimationUtils;
import android.view.animation.LayoutAnimationController;
import android.widget.ImageButton;
import android.widget.Toast;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.google.android.material.button.MaterialButton;
import com.google.android.material.floatingactionbutton.ExtendedFloatingActionButton;
import com.google.android.material.textfield.TextInputEditText;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

import me.prasad.study_app.data.entity.Subject;
import me.prasad.study_app.ui.CardManagementActivity;
import me.prasad.study_app.ui.StudySessionActivity;
import me.prasad.study_app.ui.adapter.SubjectAdapter;
import me.prasad.study_app.viewmodel.SubjectViewModel;

public class MainActivity extends AppCompatActivity {

    private final Calendar calendar = Calendar.getInstance();
    private SubjectViewModel viewModel;
    private final ActivityResultLauncher<String> importLauncher = registerForActivityResult(
            new ActivityResultContracts.GetContent(),
            uri -> {
                if (uri != null) {
                    importSubject(uri);
                }
            }
    );
    private SubjectAdapter adapter;
    private int pendingExportSubjectId = -1;
    private final ActivityResultLauncher<String> exportLauncher = registerForActivityResult(
            new ActivityResultContracts.CreateDocument("application/json"),
            uri -> {
                if (uri != null) {
                    exportSubject(uri);
                }
            }
    );

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        setupRecyclerView();

        viewModel = new ViewModelProvider(this).get(SubjectViewModel.class);
        viewModel.getAllSubjects().observe(this, subjects -> adapter.submitList(subjects));

        ExtendedFloatingActionButton fab = findViewById(R.id.fab_add_subject);
        fab.setOnClickListener(v -> showAddSubjectDialog());

        ImageButton btnImport = findViewById(R.id.btn_import);
        btnImport.setOnClickListener(v -> importLauncher.launch("application/json"));
    }

    private void importSubject(Uri uri) {
        try {
            viewModel.importSubject(getContentResolver().openInputStream(uri), () -> runOnUiThread(() -> Toast.makeText(this, "Subject imported", Toast.LENGTH_SHORT).show()));
        } catch (Exception e) {
            Toast.makeText(this, "Import failed", Toast.LENGTH_SHORT).show();
        }
    }

    private void exportSubject(Uri uri) {
        if (pendingExportSubjectId == -1) return;
        try {
            viewModel.exportSubject(pendingExportSubjectId, getContentResolver().openOutputStream(uri));
            Toast.makeText(this, "Exporting...", Toast.LENGTH_SHORT).show();
            pendingExportSubjectId = -1;
        } catch (Exception e) {
            Toast.makeText(this, "Export failed", Toast.LENGTH_SHORT).show();
        }
    }

    private void showAddSubjectDialog() {
        View view = LayoutInflater.from(this).inflate(R.layout.dialog_add_subject, null);
        TextInputEditText nameInput = view.findViewById(R.id.edit_subject_name);
        TextInputEditText dateInput = view.findViewById(R.id.edit_exam_date);
        MaterialButton btnSave = view.findViewById(R.id.btn_save);
        MaterialButton btnCancel = view.findViewById(R.id.btn_cancel);

        AlertDialog dialog = new AlertDialog.Builder(this)
                .setView(view)
                .create();

        dateInput.setOnClickListener(v -> new DatePickerDialog(this, (view1, year, month, dayOfMonth) -> {
            calendar.set(Calendar.YEAR, year);
            calendar.set(Calendar.MONTH, month);
            calendar.set(Calendar.DAY_OF_MONTH, dayOfMonth);
            SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy", Locale.getDefault());
            dateInput.setText(sdf.format(calendar.getTime()));
        }, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH)).show());

        btnSave.setOnClickListener(v -> {
            if (nameInput.getText() == null || dateInput.getText() == null) return;

            String name = nameInput.getText().toString().trim();
            if (name.isEmpty() || dateInput.getText().toString().isEmpty()) {
                Toast.makeText(this, "Please fill all fields", Toast.LENGTH_SHORT).show();
                return;
            }

            Subject subject = new Subject(name, calendar.getTimeInMillis(), 0);
            viewModel.insert(subject);
            dialog.dismiss();
        });

        btnCancel.setOnClickListener(v -> dialog.dismiss());

        dialog.show();
    }

    private void setupRecyclerView() {
        RecyclerView recyclerView = findViewById(R.id.recycler_subjects);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        LayoutAnimationController animation = AnimationUtils.loadLayoutAnimation(this, R.anim.layout_slide_up);
        recyclerView.setLayoutAnimation(animation);
        adapter = new SubjectAdapter(new ViewModelProvider(this).get(SubjectViewModel.class), this);
        recyclerView.setAdapter(adapter);

        adapter.setOnSubjectClickListener(new SubjectAdapter.OnSubjectClickListener() {
            @Override
            public void onSubjectClick(Subject subject) {
                Intent intent = new Intent(MainActivity.this, StudySessionActivity.class);
                intent.putExtra(StudySessionActivity.EXTRA_SUBJECT_ID, subject.getSubjectId());
                startActivity(intent);
            }

            @Override
            public void onManageCardsClick(Subject subject) {
                Intent intent = new Intent(MainActivity.this, CardManagementActivity.class);
                intent.putExtra(CardManagementActivity.EXTRA_SUBJECT_ID, subject.getSubjectId());
                startActivity(intent);
            }

            @Override
            public void onExportClick(Subject subject) {
                pendingExportSubjectId = subject.getSubjectId();
                String name = subject.getName();
                String fileName = (name != null ? name.replaceAll("\\s+", "_") : "subject") + ".json";
                exportLauncher.launch(fileName);
            }
        });
    }
}
