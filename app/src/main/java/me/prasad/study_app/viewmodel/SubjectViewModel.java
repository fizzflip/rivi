package me.prasad.study_app.viewmodel;

import android.app.Application;

import androidx.annotation.NonNull;
import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.LiveData;

import java.util.List;

import me.prasad.study_app.data.entity.Subject;
import me.prasad.study_app.data.repository.RiviRepository;

/**
 * ViewModel for managing Subject data.
 */
public class SubjectViewModel extends AndroidViewModel {

    private final RiviRepository repository;
    private final LiveData<List<Subject>> allSubjects;

    public SubjectViewModel(@NonNull Application application) {
        super(application);
        repository = new RiviRepository(application);
        allSubjects = repository.getAllSubjects();
    }

    public LiveData<List<Subject>> getAllSubjects() {
        return allSubjects;
    }

    public LiveData<Subject> getSubjectById(int subjectId) {
        return repository.getSubjectById(subjectId);
    }

    public LiveData<Integer> getDueCount(int subjectId) {
        return repository.getDueCountForSubject(subjectId, System.currentTimeMillis());
    }

    public void insert(Subject subject) {
        repository.insertSubject(subject);
    }

    public void update(Subject subject) {
        repository.updateSubject(subject);
    }

    public void delete(Subject subject) {
        repository.deleteSubject(subject);
    }
}
