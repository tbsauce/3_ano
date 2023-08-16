package com.example.arec

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.SeekBar
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import com.example.arec.databinding.RegisterBinding
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.storage.FirebaseStorage
import java.util.*

class Register : Fragment() {

    var database: FirebaseDatabase? = null
    lateinit var binding : RegisterBinding
    var selectedImage: String? = ""
    var age : Int = 18
    var gender : String? = ""
    var show : String? = ""
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        binding = DataBindingUtil.inflate<RegisterBinding>(inflater, R.layout.register,container,false)

        // hide the action bar
        (requireActivity() as AppCompatActivity).supportActionBar?.hide()

        database = FirebaseDatabase.getInstance()


        binding.ageSeekBar.progress = age
        binding.ageLabel.text = "Age: $age"

        binding.ageSeekBar.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
            override fun onProgressChanged(seekBar: SeekBar?, progress: Int, fromUser: Boolean) {
                // Update the TextView with the current progress value
                binding.ageLabel.text = "Age: $progress"
                age = progress
            }

            override fun onStartTrackingTouch(seekBar: SeekBar?) {
                // Do nothing
            }

            override fun onStopTrackingTouch(seekBar: SeekBar?) {
                // Do nothing
            }
        })

        binding.profileImage.setOnClickListener{
            val intent = Intent()
            intent.action = Intent.ACTION_GET_CONTENT
            intent.type = "image/*"
            startActivityForResult(intent,45)
        }

        binding.btnSignup.setOnClickListener {view : View ->
            val bundleRegisterOtp = Bundle()
            val name = binding.edtName.text.toString()
            val phone = binding.edtPhone.text.toString()
            //gets value checked on gender
            when(binding.genderRadioGroup.checkedRadioButtonId)  {
                R.id.male_radio_button->
                    gender = "male"
                R.id.female_radio_button->
                    gender = "female"
                R.id.other_radio_button->
                    gender = "other"
            }
            //gets value checked on sexual orientaion
            when(binding.sexualOrientationRadioGroup.checkedRadioButtonId)  {
                R.id.males_radio_button->
                    show = "males"
                R.id.females_radio_button->
                    show = "females"
                R.id.either_radio_button->
                    show = "everyone"
            }
            if(name == ""){
                binding.edtName.setError("Please type a name")
            }
            if(phone == ""){
                binding.edtPhone.setError("Please type a phone")
            }
            if(selectedImage == ""){
                Toast.makeText(requireContext(), "Please select an Image", Toast.LENGTH_LONG).show()
            }
            if(!(name == "" || phone == "" || selectedImage == "")){
                bundleRegisterOtp.putString("phone", phone)
                bundleRegisterOtp.putString("name", name)
                bundleRegisterOtp.putString("selectedImage", selectedImage)
                bundleRegisterOtp.putInt("age", age)
                bundleRegisterOtp.putString("gender", gender)
                bundleRegisterOtp.putString("show", show)
                view.findNavController().navigate(R.id.action_register_to_OTP, bundleRegisterOtp)
            }


        }
        return binding.root
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        val builder = AlertDialog.Builder(requireContext())
        val view = LayoutInflater.from(requireContext()).inflate(R.layout.progress_bar, null)
        builder.setView(view)
        builder.setCancelable(false)
        val dialog = builder.create()
        dialog.show()
        if (data != null) {
            if(data.data != null) {
                val uri = data.data // filePath
                val storage = FirebaseStorage.getInstance()
                val time = Date().time
                val reference = storage.reference
                    .child("Profile")
                    .child(time.toString() + "")
                reference.putFile(uri!!).addOnCompleteListener { task ->
                    if(task.isSuccessful) {
                        reference.downloadUrl.addOnCompleteListener{ uri ->
                            selectedImage = uri.result.toString()
                            Log.e("noob", selectedImage!!)
                            dialog.dismiss()
                        }
                    }
                    else
                        Log.e("noob", "n deu??")
                }

                binding!!.profileImage.setImageURI(data.data)

            }
        }
    }


}