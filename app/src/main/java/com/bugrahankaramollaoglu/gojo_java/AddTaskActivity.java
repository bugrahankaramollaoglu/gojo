package com.bugrahankaramollaoglu.gojo_java;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteStatement;
import android.os.Bundle;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.Toast;

import com.bugrahankaramollaoglu.gojo_java.databinding.ActivityAddTaskBinding;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

public class AddTaskActivity extends AppCompatActivity {

    private ActivityAddTaskBinding binding;
    private Intent intent;
    SQLiteDatabase database;
    FirebaseUser currentUser;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityAddTaskBinding.inflate(getLayoutInflater());
        View view = binding.getRoot();
        setContentView(view);

        getSupportActionBar().setTitle("ADD TASK");

        intent = new Intent(AddTaskActivity.this, TasksActivity.class);


        binding.switchButton.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                intent.putExtra("isSwitchedKey", b);
            }
        });

    }

    public void saveTask(View view) {

        String taskName = binding.taskNameText.getText().toString();
        String taskDetails = binding.taskDetailsText.getText().toString();
        currentUser = FirebaseAuth.getInstance().getCurrentUser();
        String userId = currentUser.getUid();

        if (taskName.isEmpty()) {
            Toast.makeText(AddTaskActivity.this, "CANNOT BE EMPTY", Toast.LENGTH_SHORT).show();
        } else {

            try {
                database = this.openOrCreateDatabase("tasks", MODE_PRIVATE, null);

                database.execSQL("CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY, taskname VARCHAR, taskdetails VARCHAR, userid VARCHAR)");
                String sql_str = "INSERT INTO tasks (taskname, taskdetails, userid) VALUES (?, ?, ?)";
                SQLiteStatement sqLiteStatement = database.compileStatement(sql_str);
                sqLiteStatement.bindString(1, taskName);
                sqLiteStatement.bindString(2, taskDetails);
                sqLiteStatement.bindString(3, userId);
                sqLiteStatement.execute();
                database.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            startActivity(intent);
        }

    }
}