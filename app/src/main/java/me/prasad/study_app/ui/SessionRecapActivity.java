package me.prasad.study_app.ui;

import android.os.Bundle;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.button.MaterialButton;

import me.prasad.study_app.R;

public class SessionRecapActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_session_recap);

        int count = getIntent().getIntExtra("mastered_count", 0);
        TextView textSubtitle = findViewById(R.id.text_recap_subtitle);
        textSubtitle.setText(getString(R.string.recap_subtitle, count));

        MaterialButton btnFinish = findViewById(R.id.btn_finish);
        btnFinish.setOnClickListener(v -> finish());
    }
}
