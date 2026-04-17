package me.prasad.study_app;

import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.google.android.material.floatingactionbutton.ExtendedFloatingActionButton;

import me.prasad.study_app.ui.adapter.SubjectAdapter;
import me.prasad.study_app.viewmodel.SubjectViewModel;

public class MainActivity extends AppCompatActivity {

    private SubjectViewModel viewModel;
    private SubjectAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        setupRecyclerView();

        viewModel = new ViewModelProvider(this).get(SubjectViewModel.class);
        viewModel.getAllSubjects().observe(this, subjects -> {
            adapter.submitList(subjects);
        });

        ExtendedFloatingActionButton fab = findViewById(R.id.fab_add_subject);
        fab.setOnClickListener(v -> {
            // TODO: Implement Add Subject Dialog
        });
    }

    private void setupRecyclerView() {
        RecyclerView recyclerView = findViewById(R.id.recycler_subjects);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        adapter = new SubjectAdapter();
        recyclerView.setAdapter(adapter);

        adapter.setOnSubjectClickListener(subject -> {
            // TODO: Navigate to Study Session or Subject Details
        });
    }
}
