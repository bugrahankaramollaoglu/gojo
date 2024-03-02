package com.bugrahankaramollaoglu.gojo

import android.animation.ObjectAnimator
import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Typeface
import android.os.Bundle
import android.text.SpannableString
import android.text.SpannableStringBuilder
import android.text.style.StyleSpan
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.PopupMenu
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.core.content.res.ResourcesCompat
import androidx.fragment.app.Fragment
import com.bugrahankaramollaoglu.gojo.databinding.FragmentAddTaskBinding
import com.google.firebase.Firebase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.firestore.firestore
import java.util.Calendar

class TasksAddTaskFragment : Fragment() {

    private lateinit var binding: FragmentAddTaskBinding
    var currentUser: FirebaseUser? = null
    private var db = Firebase.firestore

    var fiveMinute: String = "5 dakika önceden hatırlat"
    var fifteenMinute: String = "15 dakika önceden hatırlat"
    var thirtyMinute: String = "30 dakika önceden hatırlat"
    var sixtyMinute: String = "60 dakika önceden hatırlat"

    private lateinit var sharedPreferences: SharedPreferences
    private var currentFont: String? = "times"
    private var currentTheme: String? = "light"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        sharedPreferences =
            requireActivity().getSharedPreferences("shared_pref", Context.MODE_PRIVATE)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = FragmentAddTaskBinding.inflate(inflater, container, false)

        currentFont = sharedPreferences.getString("font-key", "times")
        currentTheme = sharedPreferences.getString("theme-key", "light")
        applyFont(currentFont)
        apply_theme(currentTheme)

        return binding.root
    }

    private fun apply_theme(currentTheme: String?) {

        if (currentTheme.equals("dark")) {

            binding.addTaskFragment.setBackgroundColor(
                ContextCompat.getColor(
                    requireContext(),
                    R.color.color4
                )
            )

        } else {
            binding.addTaskFragment.setBackgroundColor(
                ContextCompat.getColor(
                    requireContext(),
                    R.color.color1
                )
            )
        }


    }


    private fun applyFont(currentFont: String?) {
        val typeface: Typeface? = when {
            currentFont!!.isNotBlank() -> {
                val fontResId =
                    requireContext().resources.getIdentifier(
                        currentFont,
                        "font",
                        requireContext().packageName
                    )
                ResourcesCompat.getFont(requireContext(), fontResId)
            }

            else -> null
        }

        typeface?.let { it ->
            binding.taskHeaderText.typeface = it
            binding.taskDetailsText.typeface = it
            binding.taskDueDate.typeface = it
            binding.taskDueTime.typeface = it
            binding.reminder.typeface = it
            binding.saveButton.typeface = it
            binding.resetButton.typeface = it
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        currentUser = FirebaseAuth.getInstance().currentUser

        (activity as AppCompatActivity).supportActionBar?.show()

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
                R.id.option_5mn -> {

                    val spannableFive = SpannableStringBuilder(fiveMinute)
                    val boldSpan = StyleSpan(Typeface.BOLD)

                    spannableFive.setSpan(boldSpan, 0, 1, SpannableString.SPAN_INCLUSIVE_INCLUSIVE)
                    binding.reminder.setText(spannableFive)

                    true
                }

                R.id.option_15mn -> {
                    val spannableFifteen = SpannableStringBuilder(fifteenMinute)
                    val boldSpan = StyleSpan(Typeface.BOLD)

                    spannableFifteen.setSpan(
                        boldSpan,
                        0,
                        2,
                        SpannableString.SPAN_INCLUSIVE_INCLUSIVE
                    )
                    binding.reminder.setText(spannableFifteen)

                    true
                }

                R.id.option_30mn -> {
                    val spannableThirty = SpannableStringBuilder(thirtyMinute)
                    val boldSpan = StyleSpan(Typeface.BOLD)

                    spannableThirty.setSpan(
                        boldSpan,
                        0,
                        2,
                        SpannableString.SPAN_INCLUSIVE_INCLUSIVE
                    )
                    binding.reminder.setText(spannableThirty)

                    true
                }

                R.id.option_60mn -> {
                    val spannableSixty = SpannableStringBuilder(sixtyMinute)
                    val boldSpan = StyleSpan(Typeface.BOLD)

                    spannableSixty.setSpan(boldSpan, 0, 2, SpannableString.SPAN_INCLUSIVE_INCLUSIVE)
                    binding.reminder.setText(spannableSixty)
                    true
                }


                else -> false
            }
        }
        popupMenu.show()
    }

    private fun saveTask() {
        val taskHeader = binding.taskHeaderText.text.toString()
        val taskDetails = binding.taskDetailsText.text.toString()
        val taskDate = binding.taskDueDate.text.toString()
        val taskTime = binding.taskDueTime.text.toString()
        val notificationBefore = binding.reminder.text.toString()

        logInputs(taskHeader, taskDetails, taskDate, taskTime, notificationBefore)

        if (taskHeader.isEmpty()) {
            Toast.makeText(requireContext(), "Task title cannot be empty.", Toast.LENGTH_SHORT)
                .show()
            shine()
        } else {
            currentUser?.let { user ->
                val userId = user.uid
                try {

//                    var header: String,
//                    var details: String,
//                    var userId: String,
//                    var taskId: Int,
//                    var deadline: Date

//                    val myTask = MyTask(taskHeader, taskDetails, taskTime)


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

//    fun logDatabaseContents() {
//        try {
//            val database = requireContext().openOrCreateDatabase("tasks", MODE_PRIVATE, null)
//            val cursor = database.rawQuery("SELECT * FROM tasks", null)
//
//            if (cursor == null) {
//                Log.d("mesaj", "cursor null")
//            }
//            if (cursor != null && cursor.moveToFirst()) {
//                Log.d("mesaj", "girdi2")
//                val idIndex = cursor.getColumnIndex("id")
//                val headerIndex = cursor.getColumnIndex("taskheader")
//                val detailsIndex = cursor.getColumnIndex("taskdetails")
//                val userIdIndex = cursor.getColumnIndex("userid")
//                val dateIndex = cursor.getColumnIndex("taskdate")
//                val timeIndex = cursor.getColumnIndex("tasktime")
//                val notificationIndex = cursor.getColumnIndex("notification")
//
//                do {
//                    val taskId = cursor.getInt(idIndex)
//                    val taskHeader = cursor.getString(headerIndex)
//                    val taskDetails = cursor.getString(detailsIndex)
//                    val userId = cursor.getString(userIdIndex)
//                    val date = cursor.getString(dateIndex)
//                    val time = cursor.getString(timeIndex)
//                    val notification = cursor.getInt(notificationIndex)
//
//                    // Log the task details
//                    Log.d(
//                        "mesaj",
//                        "Task ID: $taskId, Header: $taskHeader, Details: $taskDetails, " +
//                                "User ID: $userId, Date: $date, Time: $time, Notification: $notification"
//                    )
//                } while (cursor.moveToNext())
//            } else {
//                Log.d("mesaj", "No data found in the database.")
//            }
//
//            cursor?.close()
//            database.close()
//        } catch (e: Exception) {
//            e.printStackTrace()
//            Log.d("mesaj", "hata")
//        }
//    }

//    private fun initializeDatabase() {
//        try {
//            database = requireContext().openOrCreateDatabase("tasks", MODE_PRIVATE, null)
//            database?.execSQL("CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY, taskheader VARCHAR, taskdetails VARCHAR, taskdate DATE, tasktime TIME, notification INTEGER, userid VARCHAR)")
//            Log.d("mesaj", "Database initialized successfully")
//        } catch (e: Exception) {
//            e.printStackTrace()
//            Log.e("mesaj", "Error initializing database: ${e.message}")
//        }
//    }


    private fun shine() {
        // Create ObjectAnimator to animate alpha property of the EditText
        val objectAnimator = ObjectAnimator.ofFloat(binding.taskHeaderText, "alpha", 1f, 0.5f, 1f)
        objectAnimator.duration = 800 // Set duration for the animation
        objectAnimator.repeatCount = 1 // Repeat the animation 3 times
        objectAnimator.start() // Start the animation
    }


}