package com.bugrahankaramollaoglu.gojo

import android.widget.CheckBox
import java.util.Date


data class Task(
    var header: CheckBox,
    var details: String,
    var userId: String,
    var taskId: Int,
    var deadline: Date
)

