package com.bugrahankaramollaoglu.gojo

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ListView
import android.widget.Toast
import androidx.fragment.app.Fragment
import com.bugrahankaramollaoglu.gojo.databinding.FragmentOptionsBinding


class OptionsFragment : Fragment() {

    private lateinit var binding: FragmentOptionsBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        binding = FragmentOptionsBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.goBack.setOnClickListener {
            requireActivity().onBackPressed()
        }


        val listView = view.findViewById<ListView>(R.id.listView)

        val settingsList = listOf(
            Option(R.drawable.font, "Yazı Tipini Değiştir", R.drawable.right),
            Option(R.drawable.baseline_dark_mode_24, "Temayı Değiştir", R.drawable.right),
            Option(R.drawable.avatar2, "Kullanıcıları Gör", R.drawable.right),
            Option(R.drawable.reset2, "Fabrika Ayarları", R.drawable.right),
            Option(R.drawable.bugra2, "Hakkımda", R.drawable.right),
        )

        val adapter = OptionsAdapter(requireContext(), settingsList)
        listView.adapter = adapter

        listView.setOnItemClickListener { parent, view, position, id ->
            val selectedItem = adapter.getItem(position) as Option
            when (selectedItem.text) {

                "Yazı Tipini Değiştir" -> {

                    Toast.makeText(
                        requireContext(),
                        "you clciked on change font",
                        Toast.LENGTH_SHORT
                    ).show()

                }

                "Temayı Değiştir" -> {

                    Toast.makeText(
                        requireContext(),
                        "you clciked on change theme",
                        Toast.LENGTH_SHORT
                    ).show()


                }

                "Kullanıcıları Gör" -> {

                    Toast.makeText(requireContext(), "you clciked on see users", Toast.LENGTH_SHORT)
                        .show()


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
}