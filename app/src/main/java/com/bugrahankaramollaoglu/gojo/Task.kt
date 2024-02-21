package com.bugrahankaramollaoglu.gojo

import java.util.Date


data class Task(
    var header: String,
    var details: String,
    var userId: String,
    var taskId: Int,
    var deadline: Date
)

