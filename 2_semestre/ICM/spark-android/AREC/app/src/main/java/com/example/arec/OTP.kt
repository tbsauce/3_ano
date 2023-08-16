package com.example.arec

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import com.example.arec.databinding.OtpBinding
import com.example.arec.model.User
import com.google.firebase.FirebaseException
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.PhoneAuthCredential
import com.google.firebase.auth.PhoneAuthOptions
import com.google.firebase.auth.PhoneAuthProvider
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import com.mukeshsolanki.OtpView
import java.util.concurrent.TimeUnit

class OTP : Fragment() {

    private var verificationId: String = ""
    private lateinit var otpView: OtpView
    private lateinit var auth: FirebaseAuth
    private lateinit var database: DatabaseReference

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val binding = DataBindingUtil.inflate<OtpBinding>(inflater, R.layout.otp,container,false)

        auth = FirebaseAuth.getInstance()
        otpView = binding.otpView

        val phone = arguments?.getString("phone")
        val name = arguments?.getString("name")
        val image = arguments?.getString("selectedImage")
        val age = arguments?.getInt("age")
        val gender = arguments?.getString("gender")
        val show = arguments?.getString("show")
        binding.phoneLabel.text = "Verify $phone"


        val options = PhoneAuthOptions.newBuilder(auth)
            .setPhoneNumber(phone!!)       // Phone number to verify
            .setTimeout(60L, TimeUnit.SECONDS) // Timeout and unit
            .setActivity(requireActivity())        // Fragment's hosting activity
            .setCallbacks(object: PhoneAuthProvider.OnVerificationStateChangedCallbacks() {
                override fun onVerificationCompleted(p0: PhoneAuthCredential) {
                    TODO("Not yet implemented")
                }

                override fun onVerificationFailed(p0: FirebaseException) {
                    Toast.makeText(requireContext(), "Failed", Toast.LENGTH_SHORT).show()
                }

                override fun onCodeSent(verifyId: String, forceResendingToken: PhoneAuthProvider.ForceResendingToken) {
                    super.onCodeSent(verifyId, forceResendingToken)
                    verificationId = verifyId

                    otpView.setOtpCompletionListener {otp ->
                        val credential = PhoneAuthProvider.getCredential(verificationId!!, otp)
                        auth!!.signInWithCredential(credential)
                            .addOnCompleteListener {task ->
                                if(task.isSuccessful) {
                                    if(name != null) {
                                        addUserToDatabase(name!!,phone,auth.currentUser?.uid!!, age!!, gender!!, show!!,  image!!)
                                    }
                                    view?.findNavController()?.navigate(R.id.action_OTP_to_mapsFragment)
                                    Toast.makeText(requireContext(), "Success", Toast.LENGTH_SHORT).show()
                                } else {
                                    Toast.makeText(requireContext(), "Failed", Toast.LENGTH_SHORT).show()
                                }
                            }
                    }
                }

            })          // OnVerificationStateChangedCallbacks
            .build()

        PhoneAuthProvider.verifyPhoneNumber(options)

        return binding.root
    }


    private fun addUserToDatabase(name: String, phone: String, uid:String, age:Int, gender:String, show : String ,image:String) {
        database = FirebaseDatabase.getInstance().getReference()

        database.child("users").child(uid).setValue(User(name,phone,uid, age, gender, show,"", image))

    }
}
