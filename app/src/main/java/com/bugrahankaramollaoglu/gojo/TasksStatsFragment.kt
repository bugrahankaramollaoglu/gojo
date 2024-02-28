package com.bugrahankaramollaoglu.gojo

import android.content.Context
import android.content.SharedPreferences
import android.graphics.Typeface
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.core.content.res.ResourcesCompat
import androidx.fragment.app.Fragment
import com.bugrahankaramollaoglu.gojo.databinding.FragmentTasksStatsBinding

class TasksStatsFragment : Fragment() {

    private lateinit var binding: FragmentTasksStatsBinding
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
    ): View? {
        binding = FragmentTasksStatsBinding.inflate(inflater, container, false)

        currentFont = sharedPreferences.getString("font-key", "times")
        currentTheme = sharedPreferences.getString("theme-key", "light")
        applyFont(currentFont)
        apply_theme(currentTheme)

        return binding.root
    }

    private fun apply_theme(currentTheme: String?) {

        if (currentTheme.equals("dark")) {

            binding.statsFragment.setBackgroundColor(
                ContextCompat.getColor(
                    requireContext(),
                    R.color.color4
                )
            )

        } else {
            binding.statsFragment.setBackgroundColor(
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
            binding.tasksText.typeface = it
            binding.completedTasksText.typeface = it
            binding.credentialsText.typeface = it
            binding.signedUpDateText.typeface = it
        }
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

    }
}