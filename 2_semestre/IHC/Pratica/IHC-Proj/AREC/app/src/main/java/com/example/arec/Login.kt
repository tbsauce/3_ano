package com.example.arec

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import androidx.navigation.fragment.findNavController
import com.example.arec.databinding.LoginBinding
import com.example.arec.model.User
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ValueEventListener

class Login : Fragment() {

    private lateinit var auth: FirebaseAuth
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val binding = DataBindingUtil.inflate<LoginBinding>(inflater, R.layout.login,container,false)

        // hide the action bar
        (requireActivity() as AppCompatActivity).supportActionBar?.hide()

        auth = FirebaseAuth.getInstance()

        if (auth!!.currentUser != null) {
            findNavController().navigate(R.id.action_login_to_maps)
        }

        binding.btnSignup.setOnClickListener { view : View ->
            view.findNavController().navigate(R.id.action_login_to_register)
        }

        binding.btnLogin.setOnClickListener { view : View ->
            //code for loggin in
            val bundleLoginOtp = Bundle()
            val phone = binding.edtPhone.text.toString()
            var exists : Boolean = false
            if(!phone.equals("")) {
                FirebaseDatabase.getInstance().reference.child("users").addValueEventListener(object :
                    ValueEventListener {
                    override fun onDataChange(snapshot: DataSnapshot) {
                        for(snapshot1 in snapshot.children) {
                            val user: User? = snapshot1.getValue(User::class.java)
                            if(user!!.phoneNumber.equals(phone)) {
                                bundleLoginOtp.putString("phone", phone)
                                exists = true
                                view.findNavController().navigate(R.id.action_login_to_OTP, bundleLoginOtp)
                            }
                        }
                        if(!exists)
                            Toast.makeText(requireContext(), "User doesn't exist, Register!", Toast.LENGTH_SHORT).show()
                    }

                    override fun onCancelled(error: DatabaseError) {}

                })

            }
            else{
                Toast.makeText(requireContext(), "Phone required to Login", Toast.LENGTH_LONG).show()
            }
        }

        return binding.root
    }
}