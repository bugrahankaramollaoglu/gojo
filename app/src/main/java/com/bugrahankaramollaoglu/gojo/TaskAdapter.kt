package com.bugrahankaramollaoglu.gojo

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.CheckBox
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class TaskAdapter(private val myTaskList: List<MyTask>) :
    RecyclerView.Adapter<TaskAdapter.TaskHolder>() {

    inner class TaskHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        var rwHeader: CheckBox = itemView.findViewById(R.id.rw_header)
        var rwDetails: TextView = itemView.findViewById(R.id.rw_details)
    }

    private fun formatDate(date: Date): String {
        val sdf = SimpleDateFormat("dd-MM", Locale.getDefault())
        return sdf.format(date)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TaskHolder {
        val itemView =
            LayoutInflater.from(parent.context).inflate(R.layout.recycler_row, parent, false)
        return TaskHolder(itemView)
    }

    override fun onBindViewHolder(holder: TaskHolder, position: Int) {
        val currentTask = myTaskList[position]
//        holder.rwHeader.text = currentTask.header.toString()
//        holder.rwDetails.text = currentTask.details
    }

    override fun getItemCount(): Int {
        return myTaskList.size
    }
}


//fun deleteTask(position: Int) {
//    val taskId: Int =
//        taskslist.get(position).id // Assuming id is the identifier for tasks in the database
//    taskslist.remove(position)
//    database.execSQL("DELETE FROM tasks WHERE id=?", arrayOf<Any>(taskId))
//    notifyItemRemoved(position)
//}