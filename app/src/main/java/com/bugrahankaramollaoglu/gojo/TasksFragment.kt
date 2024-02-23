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
//            binding.userEmail.setText(currentUser.email)
        }



        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.logoutButton.setOnClickListener {
            logout()
        }

        binding.goBack.setOnClickListener {
            requireActivity().onBackPressed()
        }

        binding.bottomNavigation.setOnItemSelectedListener { menuItem ->
            when (menuItem.itemId) {
                R.id.navigation_tasks -> {
                    // Handle Home item click
                    // You can navigate to the HomeFragment or perform any action you want
                    mainActivity.launchTaskFragment(TasksTasksFragment())
                    true
                }

                R.id.navigation_add -> {
                    // Handle Dashboard item click
                    // You can navigate to the DashboardFragment or perform any action you want
                    mainActivity.launchTaskFragment(AddTaskFragment())
                    true
                }

                R.id.navigation_stats -> {
                    // Handle Notifications item click
                    // You can navigate to the NotificationsFragment or perform any action you want
                    mainActivity.launchTaskFragment(TasksStatsFragment())
                    true
                }

                else -> false
            }
        }


    }


    fun logout() {
        val builder: AlertDialog.Builder = AlertDialog.Builder(requireContext())
        builder.setTitle("DİKKAT")
        builder.setMessage("Hesabınızdan Çıkış Yapmak İstiyor Musunuz?")
        builder.setPositiveButton("Evet") { dialogInterface, _ ->
            FirebaseAuth.getInstance().signOut()
            mainActivity.launchFragment(HomeFragment())
        }
        builder.setNegativeButton("Hayır") { dialogInterface, _ ->


        }
        val dialog: AlertDialog = builder.create()
        dialog.show()
    }
}