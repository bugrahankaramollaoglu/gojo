package com.bugrahankaramollaoglu.gojo

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.app.AlertDialog
import androidx.fragment.app.Fragment
import com.bugrahankaramollaoglu.gojo.databinding.FragmentTasksBinding
import com.google.firebase.auth.FirebaseAuth

class TasksFragment : Fragment() {

    private lateinit var binding: FragmentTasksBinding
    private lateinit var mainActivity: MainActivity
    private lateinit var mAuth: FirebaseAuth


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mainActivity = activity as MainActivity
        mAuth = FirebaseAuth.getInstance()
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = FragmentTasksBinding.inflate(inflater, container, false)

        val currentUser = mAuth.currentUser
        currentUser?.let {
            binding.userEmail.setText(currentUser.email)
        }



        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.logoutButton.setOnClickListener {
            logout()
        }

    }


    fun logout() {
        val builder: AlertDialog.Builder = AlertDialog.Builder(requireContext())
        builder.setTitle("WARNING")
        builder.setMessage("Are you sure you want to log out?")
        builder.setPositiveButton("Yes") { dialogInterface, _ ->
            FirebaseAuth.getInstance().signOut()
            mainActivity.launchFragment(HomeFragment())
        }
        builder.setNegativeButton("No") { dialogInterface, _ -> }
        val dialog: AlertDialog = builder.create()
        dialog.show()
    }
}