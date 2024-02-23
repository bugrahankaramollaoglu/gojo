package com.bugrahankaramollaoglu.gojo

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import com.bugrahankaramollaoglu.gojo.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        launchFragment(HomeFragment())
    }

    fun launchFragment(fragment: Fragment) {
        val fragment_manager = supportFragmentManager
        val transaction = fragment_manager.beginTransaction()
        transaction.replace(R.id.fragment_container, fragment)
        transaction.addToBackStack(null)
        transaction.commit()
    }

    fun launchAnimatedFragment(fragment: Fragment) {
        val transaction = supportFragmentManager.beginTransaction()
        transaction.setCustomAnimations(
            R.anim.slide_in_right,   // Enter from right
            R.anim.slide_out_left,   // Exit to left
            R.anim.slide_in_left,    // Pop enter from left
            R.anim.slide_out_right   // Pop exit to right
        )
        transaction.replace(R.id.fragment_container, fragment)
        transaction.addToBackStack(null)
        transaction.commit()
    }

}