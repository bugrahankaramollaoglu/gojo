package com.bugrahankaramollaoglu.gojo_java;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;

import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.telecom.Call;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.Toast;

import com.bugrahankaramollaoglu.gojo_java.databinding.ActivityTasksBinding;
import com.google.android.gms.tasks.Tasks;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

import java.util.ArrayList;

public class TasksActivity extends AppCompatActivity {

    private ActivityTasksBinding binding;
    ArrayList<Task> taskList;
    SQLiteDatabase database;
    Intent intent;
    Boolean isSwitched;
    TaskAdapter taskAdapter;
    FirebaseUser currentUser;
    String userId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityTasksBinding.inflate(getLayoutInflater());
        View view = binding.getRoot();
        setContentView(view);


        intent = getIntent();
        isSwitched = intent.getBooleanExtra("isSwitchedKey", false);
        // TODO use this isSwitched later on for ordering by urgency

        binding.fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(TasksActivity.this, AddTaskActivity.class);
                startActivity(intent);
            }
        });

        currentUser = FirebaseAuth.getInstance().getCurrentUser();
        userId = currentUser.getUid();

        String userEmail = currentUser.getEmail();
        int atIndeks = userEmail.indexOf('@');
        String username = (atIndeks != -1) ? userEmail.substring(0, atIndeks) : "";
// TODO        Toast.makeText(TasksActivity.this, "Logged in as " + username, Toast.LENGTH_SHORT).show();

        getSupportActionBar().setTitle("TASKS FOR " + username);

        database = this.openOrCreateDatabase("tasks", MODE_PRIVATE, null);

        taskList = new ArrayList<Task>();
        taskAdapter = new TaskAdapter(taskList, database);
        binding.recyclerView.setAdapter(taskAdapter);
        binding.recyclerView.setLayoutManager(new LinearLayoutManager(this));

        getData();

    }

    public void getData() {
        try {
            Cursor cursor = database.rawQuery("SELECT * FROM tasks WHERE userId = ?", new String[]{userId});
            int nameIndeks = cursor.getColumnIndex("taskname");
            int detailsIndeks = cursor.getColumnIndex("taskdetails");
            int idIndeks = cursor.getColumnIndex("id");
            int useridIndeks = cursor.getColumnIndex("userid");

            while (cursor.moveToNext()) {
                String name = cursor.getString(nameIndeks);
                String details = cursor.getString(detailsIndeks);
                String userid = cursor.getString(useridIndeks);
                int id = cursor.getInt(idIndeks);
                Task task = new Task(name, details, userid, id);
                taskList.add(task);
            }
            taskAdapter.notifyDataSetChanged();
            cursor.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteDb() {

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("WARNING");
        builder.setMessage("Are you sure to delete database for the user?");

        builder.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
                database = getApplication().openOrCreateDatabase("tasks", MODE_PRIVATE, null);
                database.execSQL("DELETE FROM tasks WHERE userId=?", new String[]{userId});
                taskList.clear();
                taskAdapter.notifyDataSetChanged();
                Toast.makeText(TasksActivity.this, "All data have been deleted for the user.", Toast.LENGTH_SHORT).show();
                database.close();
            }
        });

        builder.setNegativeButton("No", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
            }
        });

        builder.create().show();
    }

    public void logout() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("WARNING");
        builder.setMessage("Are you sure to log out?");

        builder.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
                FirebaseAuth.getInstance().signOut();
                intent = new Intent(TasksActivity.this, MainActivity.class);
                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);
            }
        });

        builder.setNegativeButton("No", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void changeTheme() {

    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater menuInflater = getMenuInflater();
        menuInflater.inflate(R.menu.options_menu, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {

        if (item.getItemId() == R.id.deletedbItem) {
            deleteDb();
        } else if (item.getItemId() == R.id.logoutItem) {
            logout();
        }

        return super.onOptionsItemSelected(item);
    }
}
