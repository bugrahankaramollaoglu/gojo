package com.bugrahankaramollaoglu.gojo

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import com.bugrahankaramollaoglu.gojo.databinding.FragmentHomeBinding
import com.google.firebase.auth.FirebaseAuth


class HomeFragment : Fragment() {

    private lateinit var binding: FragmentHomeBinding
    private var auth: FirebaseAuth? = null
    private lateinit var mainActivity: MainActivity


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        mainActivity = activity as MainActivity

    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = FragmentHomeBinding.inflate(inflater, container, false)

        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        auth = FirebaseAuth.getInstance();
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

        binding.signupButton.setOnClickListener {

            val email = binding.emailText.text.toString()
            val password = binding.passwordText.text.toString()

            if (email.isEmpty() || password.isEmpty() || email.isBlank() || password.isBlank()) {
                Toast.makeText(
                    requireContext(),
                    "Email and password cannot be empty!",
                    Toast.LENGTH_SHORT
                ).show()
            } else {
                auth!!.createUserWithEmailAndPassword(email, password).addOnSuccessListener {
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

}