package me.prasad.study_app.ui;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import me.prasad.study_app.R;
import com.google.android.material.button.MaterialButton;

public class SessionRecapActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_session_recap);

        MaterialButton btnFinish = findViewById(R.id.btn_finish);
        btnFinish.setOnClickListener(v -> finish());
    }
}
