package com.bugrahankaramollaoglu.gojo_java;

import android.content.DialogInterface;
import android.database.sqlite.SQLiteDatabase;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.recyclerview.widget.RecyclerView;


import com.bugrahankaramollaoglu.gojo_java.databinding.RecyclerRowBinding;

import java.util.ArrayList;

public class TaskAdapter extends RecyclerView.Adapter<TaskAdapter.TaskHolder> {

    ArrayList<Task> taskslist;
    public SQLiteDatabase database;

    public TaskAdapter(ArrayList<Task> taskslist, SQLiteDatabase database) {
        this.taskslist = taskslist;
        this.database = database;
    }

    public void deleteTask(int position) {
        int taskId = taskslist.get(position).id; // Assuming id is the identifier for tasks in the database
        taskslist.remove(position);
        database.execSQL("DELETE FROM tasks WHERE id=?", new Object[]{taskId});
        notifyItemRemoved(position);
    }

    @NonNull
    @Override
    public TaskHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        RecyclerRowBinding recyclerRowBinding = RecyclerRowBinding.inflate(LayoutInflater.from(parent.getContext()), parent, false);
        return new TaskHolder(recyclerRowBinding);
    }

    @Override
    public void onBindViewHolder(@NonNull TaskHolder holder, int position) {
        holder.binding.recyclerViewTextView.setText(taskslist.get(position).name);

        holder.binding.recyclerViewTextView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Toast.makeText(holder.itemView.getContext(), "clicked on " + taskslist.get(position).name, Toast.LENGTH_SHORT).show();
            }
        });

        holder.binding.recyclerViewTextView.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View view) {
                AlertDialog.Builder builder = new AlertDialog.Builder(holder.itemView.getContext());
                builder.setTitle("WARNING");
                builder.setMessage("Are you sure to delete this task?");

                builder.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        deleteTask(position);
                    }
                });

                builder.setNegativeButton("No", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dialogInterface.dismiss();
                    }
                });

                builder.create().show();
                return true;
            }
        });
    }

    @Override
    public int getItemCount() {
        return taskslist.size();
    }

    public class TaskHolder extends RecyclerView.ViewHolder {
        private RecyclerRowBinding binding;

        public TaskHolder(RecyclerRowBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }
    }
}
