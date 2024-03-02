package com.bugrahankaramollaoglu.gojo

import android.content.Context
import android.content.SharedPreferences
import android.graphics.Typeface
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import androidx.core.content.res.ResourcesCompat
import androidx.fragment.app.Fragment
import com.bugrahankaramollaoglu.gojo.databinding.FragmentHomeBinding
import com.google.firebase.Firebase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.firestore
import java.time.LocalDate
import java.time.format.DateTimeFormatter


class HomeFragment : Fragment() {

    private lateinit var binding: FragmentHomeBinding
    private var auth: FirebaseAuth? = null
    private lateinit var mainActivity: MainActivity
    private lateinit var sharedPreferences: SharedPreferences
    private var currentFont: String? = "times"
    private var currentTheme: String? = "light"
    private var user_template = hashMapOf<String, String>()


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        mainActivity = activity as MainActivity

        sharedPreferences =
            requireActivity().getSharedPreferences("shared_pref", Context.MODE_PRIVATE)


    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = FragmentHomeBinding.inflate(inflater, container, false)

        currentFont = sharedPreferences.getString("font-key", "times")
        applyFont(currentFont)
        currentTheme = sharedPreferences.getString("theme-key", "light")
        apply_theme(currentTheme)

        return binding.root
    }


    private fun apply_theme(currentTheme: String?) {

        if (currentTheme.equals("dark")) {

            binding.homeFragment.setBackgroundColor(
                ContextCompat.getColor(
                    requireContext(),
                    R.color.color4
                )
            )

            binding.logo.setImageResource(R.drawable.cropped_final_dark)

            requireActivity().setTheme(R.style.Theme_Gojo_Color2)
            // Recreate the activity for the theme changes to take effect,

        } else {
            binding.homeFragment.setBackgroundColor(
                ContextCompat.getColor(
                    requireContext(),
                    R.color.color1
                )
            )
            binding.logo.setImageResource(R.drawable.cropped_final)
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
            binding.emailText.typeface = it
            binding.passwordText.typeface = it
            binding.signinText.typeface = it
            binding.signupText.typeface = it
            binding.forgotPasswordText.typeface = it
            binding.proverbText.typeface = it
            binding.authorText.typeface = it
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val db = Firebase.firestore
        user_template = hashMapOf(
            "email" to "xxx@hotmail.com",
            "password" to "asd123",
            "date" to "20:32"
        )


        auth = FirebaseAuth.getInstance()
        val user = auth!!.currentUser

        if (user != null) {
            mainActivity.launchFragment(TasksFragment())
        }

        binding.signinButton.setOnClickListener {
            val email = binding.emailText.text.toString()
            val password = binding.passwordText.text.toString()

            if (email.isEmpty() || password.isEmpty()) {
                Toast.makeText(
                    requireContext(),
                    "Email and password cannot be empty",
                    Toast.LENGTH_SHORT
                )
                    .show()
            } else {
                auth!!.signInWithEmailAndPassword(email, password).addOnSuccessListener {
                    mainActivity.launchFragment(TasksFragment())
                }.addOnFailureListener { e ->
                    Toast.makeText(
                        requireContext(),
                        e.localizedMessage,
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }
        }



        binding.logo.setOnClickListener {
            db.collection("users")
                .get()
                .addOnSuccessListener { result ->
                    for (document in result) {
                        Log.d("mesaj", "${document.id} => ${document.data}")
                    }
                }
                .addOnFailureListener { exception ->
                    Log.w("mesaj", "Error getting documents.", exception)
                }
        }

        binding.signupButton.setOnClickListener {

            val email = binding.emailText.text.toString()
            val password = binding.passwordText.text.toString()
            val date = getCurrentDateString()

            if (email.isEmpty() || password.isEmpty() || email.isBlank() || password.isBlank()) {
                Toast.makeText(
                    requireContext(),
                    "Email and password cannot be empty!",
                    Toast.LENGTH_SHORT
                ).show()
            } else {

                user_template = hashMapOf(
                    "email" to email,
                    "password" to password,
                    "date" to date
                )

                auth!!.createUserWithEmailAndPassword(email, password).addOnSuccessListener {
                    Toast.makeText(requireContext(), "Kayıt Başarılı!", Toast.LENGTH_SHORT).show()
                    db.collection("users")
                        .add(user_template)
                        .addOnSuccessListener { documentReference ->
                            Log.d(
                                "mesaj",
                                "DocumentSnapshot added with ID: ${documentReference.id}"
                            )
                        }
                        .addOnFailureListener { e ->
                            Log.w("mesaj", "Error adding document", e)
                        }
                }.addOnFailureListener { e ->
                    Toast.makeText(
                        requireContext(),
                        e.localizedMessage,
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }
        }

        binding.homeOptions.setOnClickListener {
            mainActivity.launchAnimatedFragment(OptionsFragment())
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun getCurrentDateString(): String {
        val currentDate = LocalDate.now()
        val formatter = DateTimeFormatter.ofPattern("d.MM.yyyy")
        return currentDate.format(formatter)
    }

}


