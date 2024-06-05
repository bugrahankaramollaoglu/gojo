package com.bugrahankaramollaoglu.gojo

import android.content.Context
import android.content.SharedPreferences
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ListView
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import com.bugrahankaramollaoglu.gojo.databinding.FragmentOptionsBinding

class OptionsFragment : Fragment() {

    private lateinit var binding: FragmentOptionsBinding
    private lateinit var sharedPreferences: SharedPreferences
    private var currentFont: String? = "times"
    private var currentTheme: String? = "light"
    private var currentNotification: Boolean = true
    private var fontIndex: Int = 0
    private var settingsList: List<Option> = listOf()
    private val fonts = arrayOf(
        "aller",
        "chillight",
        "crang",
        "fjalla",
        "merriweather",
        "poppins",
        "roboto",
        "san_francisco"
    )

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        // Inflate the layout for this fragment
        binding = FragmentOptionsBinding.inflate(inflater, container, false)

        sharedPreferences =
            requireActivity().getSharedPreferences("shared_pref", Context.MODE_PRIVATE)

        currentTheme = sharedPreferences.getString("theme-key", "light")
        apply_theme(currentTheme)

        currentFont = sharedPreferences.getString("font-key", "times")
        applyFont(currentFont)

        currentNotification = sharedPreferences.getBoolean("notification-key", true)
        applyNotification(currentNotification)

        return binding.root
    }

    private fun applyNotification(currentNotification: Boolean) {

    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.goBack.setOnClickListener {
            requireActivity().onBackPressed()
        }


        val listView = view.findViewById<ListView>(R.id.listView)

        settingsList = listOf(
            Option(R.drawable.font, "Yazı Tipini Değiştir", R.drawable.right),
            Option(R.drawable.baseline_dark_mode_24, "Temayı Değiştir", R.drawable.right),
            Option(R.drawable.notification2, "Bildirimler ", R.drawable.right),
            Option(R.drawable.reset2, "Fabrika Ayarları", R.drawable.right),
            Option(R.drawable.bugra2, "Hakkımda", R.drawable.right),
        )

        val adapter = OptionsAdapter(
            requireContext(),
            settingsList,
            currentFont,
            currentTheme,
            currentNotification
        )
        listView.adapter = adapter

        listView.setOnItemClickListener { parent, view, position, id ->
            val selectedItem = adapter.getItem(position) as Option
            when (selectedItem.text) {

                "Yazı Tipini Değiştir" -> {
                    fontIndex = (fontIndex + 1) % fonts.size
                    val selectedFont = fonts[fontIndex]
                    sharedPreferences.edit().putString("font-key", selectedFont).apply()
                    applyFont(selectedFont)
                }

                "Temayı Değiştir" -> {

                    currentTheme = if (currentTheme.equals("dark"))
                        "light"
                    else
                        "dark"
                    sharedPreferences.edit().putString("theme-key", currentTheme).apply()
                    apply_theme(currentTheme)
                    adapter.updateThemeIcon(currentTheme) // Update the icon in the adapter


                }

                "Bildirimler" -> {

                    val isNot: Boolean = if (currentNotification)
                        false
                    else
                        true
                    sharedPreferences.edit().putBoolean("notification-key", isNot).apply()
                    apply_notification(currentNotification)
                    adapter.updateNotification(currentNotification) // Update the icon in the adapter

                }

                "Fabrika Ayarları" -> {

                    Toast.makeText(requireContext(), "you clciked on factory", Toast.LENGTH_SHORT)
                        .show()

                }

                "Hakkımda" -> {

                    Toast.makeText(requireContext(), "you clciked on factory", Toast.LENGTH_SHORT)
                        .show()

                }
            }
        }

    }

    private fun apply_notification(currentNotification: Boolean) {
        TODO("Not yet implemented")
    }

    private fun apply_theme(currentTheme: String?) {

        if (currentTheme.equals("dark")) {

            binding.optionsFragment.setBackgroundColor(
                ContextCompat.getColor(
                    requireContext(),
                    R.color.color4
                )
            )


        } else {
            binding.optionsFragment.setBackgroundColor(
                ContextCompat.getColor(
                    requireContext(),
                    R.color.color1
                )
            )
        }
    }

    private fun applyFont(currentFont: String?) {

        val adapter = OptionsAdapter(
            requireContext(),
            settingsList,
            currentFont,
            currentTheme,
            currentNotification
        )
        binding.listView.adapter = adapter
        adapter.notifyDataSetChanged()
        (binding.listView.adapter as? OptionsAdapter)?.updateFont(currentFont)

    }
}