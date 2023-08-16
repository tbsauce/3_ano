package com.example.arec

import android.content.Intent
import android.os.Bundle
import android.view.*
import android.widget.SeekBar
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import androidx.navigation.ui.NavigationUI
import com.bumptech.glide.Glide
import com.example.arec.databinding.EditProfileBinding
import com.example.arec.model.User
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.*
import com.google.firebase.storage.FirebaseStorage
import java.util.*

class EditProfile : Fragment() {

    private lateinit var auth: FirebaseAuth
    private lateinit var binding: EditProfileBinding
    private lateinit var databaseReference : DatabaseReference
    private var user : User? = null
    private val selectedImageList = mutableListOf<String>()
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        binding = DataBindingUtil.inflate<EditProfileBinding>(inflater, R.layout.edit_profile,container,false)
        auth = FirebaseAuth.getInstance()
        binding.butSave.setOnClickListener { view : View ->
            user!!.name = binding.nameEdit.text.toString()
            user!!.description = binding.description.text.toString()
            //gets value checked on gender
            when(binding.genderRadioGroup.checkedRadioButtonId)  {
                R.id.male_radio_button->
                    user!!.gender = "male"
                R.id.female_radio_button->
                    user!!.gender = "female"
                R.id.other_radio_button->
                    user!!.gender = "other"
            }
            //gets value checked on sexual orientaion
            when(binding.sexualOrientationRadioGroup.checkedRadioButtonId)  {
                R.id.males_radio_button->
                    user!!.show = "males"
                R.id.females_radio_button->
                    user!!.show = "females"
                R.id.either_radio_button->
                    user!!.show = "everyone"
            }

            databaseReference.setValue(user)
                .addOnSuccessListener {
                    view.findNavController().navigate(R.id.action_editProfile_to_profileFragment)
                }

        }
        binding.deleteAccount.setOnClickListener{view : View ->
            //deletes usr
            val database = FirebaseDatabase.getInstance().reference
            database.child("users").child(auth.currentUser?.uid!!).removeValue()
            //should delete image from storage
            //signsOutuser from app
            auth.signOut()
            view.findNavController().navigate(R.id.action_editProfile_to_login)

        }
        setHasOptionsMenu(true)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        databaseReference = FirebaseDatabase.getInstance().reference.child("users")
            .child(auth.currentUser?.uid!!)

        databaseReference.addListenerForSingleValueEvent(object : ValueEventListener {
            override fun onDataChange(dataSnapshot: DataSnapshot) {
                // dataSnapshot will contain the data for the child with the specified ID
                if (dataSnapshot.exists()) {
                    // Retrieve the data from the snapshot and perform the desired operations
                    user = dataSnapshot.getValue(User::class.java)

                    binding.profileImage1.setOnClickListener {
                        val intent = Intent()
                        intent.action = Intent.ACTION_GET_CONTENT
                        intent.type = "image/*"
                        startActivityForResult(intent,45)
                    }

                    binding.profileImage2.setOnClickListener {
                        val intent = Intent()
                        intent.action = Intent.ACTION_GET_CONTENT
                        intent.type = "image/*"
                        startActivityForResult(intent,46)
                    }

                    binding.profileImage3.setOnClickListener {
                        val intent = Intent()
                        intent.action = Intent.ACTION_GET_CONTENT
                        intent.type = "image/*"
                        startActivityForResult(intent,47)
                    }

                    binding.description.setText(user!!.description)
                    binding.nameEdit.setText(user!!.name)
                    when(user!!.gender)  {
                        "male"->
                            binding.genderRadioGroup.check(R.id.male_radio_button)

                        "female"->
                            binding.genderRadioGroup.check(R.id.female_radio_button)

                        "other"->
                            binding.genderRadioGroup.check(R.id.other_radio_button)

                    }
                    //gets value checked on sexual orientaion
                    when(user!!.show)  {
                        "males"->
                            binding.sexualOrientationRadioGroup.check(R.id.males_radio_button)
                        "females"->
                            binding.sexualOrientationRadioGroup.check(R.id.females_radio_button)
                        "everyone"->
                            binding.sexualOrientationRadioGroup.check(R.id.either_radio_button)
                    }
                    Glide.with(context!!)
                        .load(user!!.profileImage.getOrNull(0))
                        .placeholder(R.drawable.avatar)
                        .into(binding.profileImage1)

                    Glide.with(context!!)
                        .load(user!!.profileImage.getOrNull(1))
                        .placeholder(R.drawable.avatar)
                        .into(binding.profileImage2)

                    Glide.with(context!!)
                        .load(user!!.profileImage.getOrNull(2))
                        .placeholder(R.drawable.avatar)
                        .into(binding.profileImage3)


                    binding.ageSeekBar.progress = user!!.age!!
                    binding.ageLabel.text = "Age: ${user!!.age}"

                    binding.ageSeekBar.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
                        override fun onProgressChanged(seekBar: SeekBar?, progress: Int, fromUser: Boolean) {
                            // Update the TextView with the current progress value
                            binding.ageLabel.text = "Age: $progress"
                            user!!.age = progress
                        }
                        override fun onStartTrackingTouch(seekBar: SeekBar?) {}
                        override fun onStopTrackingTouch(seekBar: SeekBar?) {}
                    })
                } else {
                    // Child with the specified ID does not exist in the database
                }
            }

            override fun onCancelled(databaseError: DatabaseError) {
                // Handle any errors that may occur while retrieving the data
            }
        })
    }

    override fun onCreateOptionsMenu(menu: Menu, inflater: MenuInflater) {
        super.onCreateOptionsMenu(menu, inflater)
        inflater.inflate(R.menu.toolbar_menu,menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return NavigationUI.onNavDestinationSelected(item, requireView().findNavController())
                || super.onOptionsItemSelected(item)
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
                            selectedImageList.add(uri.result.toString())
                            when (requestCode) {
                                45 -> { binding.profileImage1.setImageURI(data.data)
                                    if(user!!.profileImage.getOrNull(0) == null)
                                        user!!.profileImage.add(0, uri.result.toString())
                                    else
                                        user!!.profileImage.set(0, uri.result.toString())
                                }
                                46 -> { binding.profileImage2.setImageURI(data.data)
                                    if(user!!.profileImage.getOrNull(1) == null)
                                        user!!.profileImage.add(1, uri.result.toString())
                                    else
                                        user!!.profileImage.set(1, uri.result.toString())
                                }
                                else -> { binding.profileImage3.setImageURI(data.data)
                                    if(user!!.profileImage.getOrNull(2) == null)
                                        user!!.profileImage.add(2, uri.result.toString())
                                    else
                                        user!!.profileImage.set(2, uri.result.toString())
                                }
                            }
                            //Log.e("noob", selectedImageList!!)
                            dialog.dismiss()

                        }
                    }
                    else
                        Toast.makeText(requireContext(), "Couldn't load image try again.", Toast.LENGTH_SHORT).show()
                }

            }
        }
    }
}