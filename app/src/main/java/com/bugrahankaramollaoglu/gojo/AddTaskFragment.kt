package com.bugrahankaramollaoglu.gojo

import android.animation.ObjectAnimator
import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.content.Context.MODE_PRIVATE
import android.database.sqlite.SQLiteDatabase
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.PopupMenu
import android.widget.Toast
import androidx.fragment.app.Fragment
import com.bugrahankaramollaoglu.gojo.databinding.FragmentAddTaskBinding
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import java.util.Calendar


class AddTaskFragment : Fragment() {

    private lateinit var binding: FragmentAddTaskBinding
    var database: SQLiteDatabase? = null
    var currentUser: FirebaseUser? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initializeDatabase()
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = FragmentAddTaskBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        currentUser = FirebaseAuth.getInstance().currentUser

        binding.gojoText.setOnClickListener {
            logDatabaseContents()
        }

        binding.taskDueDate.setOnClickListener {
            showDatePicker()
        }

        binding.taskDueTime.setOnClickListener {
            showTimePicker()
        }

        binding.reminder.setOnClickListener {
            showReminderOptions(it)
        }

        binding.saveButton.setOnClickListener {
            saveTask()
        }

    }

    private fun showDatePicker() {
        val calendar = Calendar.getInstance()
        val year = calendar.get(Calendar.YEAR)
        val month = calendar.get(Calendar.MONTH)
        val dayOfMonth = calendar.get(Calendar.DAY_OF_MONTH)

        val datePickerDialog = DatePickerDialog(
            requireContext(),
            { _, selectedYear, selectedMonth, selectedDayOfMonth ->
                // Format the selected date to display only day and month
                val formattedDate =
                    String.format("%02d-%02d", selectedDayOfMonth, selectedMonth + 1)

                // Update the due date EditText field
                binding.taskDueDate.setText(formattedDate)
            },
            year,
            month,
            dayOfMonth
        )

        datePickerDialog.show()
    }


    private fun showTimePicker() {
        val calendar = Calendar.getInstance()
        val hour = calendar.get(Calendar.HOUR_OF_DAY)
        val minute = calendar.get(Calendar.MINUTE)

        val timePickerDialog = TimePickerDialog(
            requireContext(),
            { _, selectedHour, selectedMinute ->
                // Update the due time EditText field
                binding.taskDueTime.setText(
                    String.format(
                        "%02d:%02d",
                        selectedHour,
                        selectedMinute
                    )
                )
            },
            hour,
            minute,
            true // Set true for 24-hour time format
        )

        timePickerDialog.show()
    }

    private fun showReminderOptions(view: View) {
        val popupMenu = PopupMenu(requireContext(), view)
        popupMenu.inflate(R.menu.reminder_options)

        popupMenu.setOnMenuItemClickListener { menuItem ->
            when (menuItem.itemId) {
                R.id.action_option1 -> {

                    true
                }

                R.id.action_option2 -> {

                    true
                }

                else -> false
            }
        }
        popupMenu.show()
    }

    private fun saveTask() {
        val taskTitle = binding.taskHeaderText.text.toString()
        val taskDetails = binding.taskDetailsText.text.toString()
        val taskDate = binding.taskDueDate.text.toString()
        val taskTime = binding.taskDueTime.text.toString()
        val notificationBefore = binding.reminder.text.toString()

        logInputs(taskTitle, taskDetails, taskDate, taskTime, notificationBefore)

        if (taskTitle.isEmpty()) {
            Toast.makeText(requireContext(), "Task title cannot be empty.", Toast.LENGTH_SHORT)
                .show()
            shine(binding.taskHeaderText)
        } else {
            currentUser?.let { user ->
                val userId = user.uid
                try {
                    database = requireContext().openOrCreateDatabase("tasks", MODE_PRIVATE, null)
                    database?.execSQL("CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY, taskheader VARCHAR, taskdetails VARCHAR, taskdate DATE, tasktime TIME, notification INTEGER, userid VARCHAR)")
                    val sql_str =
                        "INSERT INTO tasks (taskheader, taskdetails, taskdate, tasktime, notification, userid) VALUES (?, ?, ?, ?, ?, ?)"
                    val sqLiteStatement = database?.compileStatement(sql_str)
                    sqLiteStatement?.bindString(1, taskTitle)
                    sqLiteStatement?.bindString(2, taskDetails)
                    sqLiteStatement?.bindString(3, taskDate)
                    sqLiteStatement?.bindString(4, taskTime)
                    sqLiteStatement?.bindString(5, notificationBefore)
                    sqLiteStatement?.bindString(6, userId)
                    sqLiteStatement?.execute()
                    database?.close()
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }
    }

    private fun logInputs(
        taskTitle: String,
        taskDetails: String,
        taskDate: String,
        taskTime: String,
        notificationBefore: String
    ) {
        Log.d(
            "mesaj",
            "here:\n${taskTitle}\n${taskDetails}\n${taskDate}\n${taskTime}\n${notificationBefore}"
        )
    }

    fun logDatabaseContents() {
        try {
            val database = requireContext().openOrCreateDatabase("tasks", MODE_PRIVATE, null)
            val cursor = database.rawQuery("SELECT * FROM tasks", null)

            if (cursor == null) {
                Log.d("mesaj", "cursor null")
            }
            if (cursor != null && cursor.moveToFirst()) {
                Log.d("mesaj", "girdi2")
                val idIndex = cursor.getColumnIndex("id")
                val headerIndex = cursor.getColumnIndex("taskheader")
                val detailsIndex = cursor.getColumnIndex("taskdetails")
                val userIdIndex = cursor.getColumnIndex("userid")
                val dateIndex = cursor.getColumnIndex("taskdate")
                val timeIndex = cursor.getColumnIndex("tasktime")
                val notificationIndex = cursor.getColumnIndex("notification")

                do {
                    val taskId = cursor.getInt(idIndex)
                    val taskHeader = cursor.getString(headerIndex)
                    val taskDetails = cursor.getString(detailsIndex)
                    val userId = cursor.getString(userIdIndex)
                    val date = cursor.getString(dateIndex)
                    val time = cursor.getString(timeIndex)
                    val notification = cursor.getInt(notificationIndex)

                    // Log the task details
                    Log.d(
                        "mesaj",
                        "Task ID: $taskId, Header: $taskHeader, Details: $taskDetails, " +
                                "User ID: $userId, Date: $date, Time: $time, Notification: $notification"
                    )
                } while (cursor.moveToNext())
            } else {
                Log.d("mesaj", "No data found in the database.")
            }

            cursor?.close()
            database.close()
        } catch (e: Exception) {
            e.printStackTrace()
            Log.d("mesaj", "hata")
        }
    }

    private fun initializeDatabase() {
        try {
            database = requireContext().openOrCreateDatabase("tasks", MODE_PRIVATE, null)
            database?.execSQL("CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY, taskheader VARCHAR, taskdetails VARCHAR, taskdate DATE, tasktime TIME, notification INTEGER, userid VARCHAR)")
            Log.d("mesaj", "Database initialized successfully")
        } catch (e: Exception) {
            e.printStackTrace()
            Log.e("mesaj", "Error initializing database: ${e.message}")
        }
    }


    private fun shine(taskHeaderText: EditText) {
        // Create ObjectAnimator to animate alpha property of the EditText
        val objectAnimator = ObjectAnimator.ofFloat(binding.taskHeaderText, "alpha", 1f, 0.5f, 1f)
        objectAnimator.duration = 700 // Set duration for the animation
        objectAnimator.repeatCount = 1 // Repeat the animation 3 times
        objectAnimator.start() // Start the animation
    }


}