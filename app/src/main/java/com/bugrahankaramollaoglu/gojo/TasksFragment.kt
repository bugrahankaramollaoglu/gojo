package com.bugrahankaramollaoglu.gojo

import android.content.Context
import android.content.SharedPreferences
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.app.AlertDialog
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import com.bugrahankaramollaoglu.gojo.databinding.FragmentTasksBinding
import com.google.firebase.auth.FirebaseAuth

class TasksFragment : Fragment() {

    private lateinit var binding: FragmentTasksBinding
    private lateinit var mainActivity: MainActivity
    private lateinit var mAuth: FirebaseAuth
    private lateinit var sharedPreferences: SharedPreferences
    private var currentTheme: String? = "light"
    private var currentFont: String? = "times"


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mainActivity = activity as MainActivity
        mAuth = FirebaseAuth.getInstance()
        sharedPreferences =
            requireActivity().getSharedPreferences("shared_pref", Context.MODE_PRIVATE)
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


        currentTheme = sharedPreferences.getString("theme-key", "light")
        apply_theme(currentTheme)

        return binding.root
    }

    private fun apply_theme(currentTheme: String?) {

        if (currentTheme.equals("dark")) {

            binding.tasksFragment.setBackgroundColor(
                ContextCompat.getColor(
                    requireContext(),
                    R.color.color4
                )
            )

        } else {
            binding.tasksFragment.setBackgroundColor(
                ContextCompat.getColor(
                    requireContext(),
                    R.color.color1
                )
            )
        }

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


                    mainActivity.launchTaskFragment(TasksTasksFragment())
                    true
                }

                R.id.navigation_add -> {
                    // Handle Dashboard item click
                    // You can navigate to the DashboardFragment or perform any action you want

                    mainActivity.launchTaskFragment(TasksAddTaskFragment())
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