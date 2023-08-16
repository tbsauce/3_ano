package com.example.arec

import android.os.Bundle
import android.view.*
import android.widget.SeekBar
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import androidx.navigation.ui.NavigationUI
import com.example.arec.databinding.CreateEventBinding
import com.example.arec.model.Event
import com.google.android.gms.maps.model.LatLng
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.FirebaseDatabase

class CreateEvent : Fragment() {

    var database: FirebaseDatabase? = null
    lateinit var binding : CreateEventBinding
    var radius : Int = 2000
    var duration : Int = 2
    var participants : Int = 20
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        binding = DataBindingUtil.inflate<CreateEventBinding>(inflater, R.layout.create_event,container,false)

        database = FirebaseDatabase.getInstance()

        setHasOptionsMenu(true)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val latlng = arguments?.getParcelable<LatLng>("LatLngUser")
        if (latlng != null){
            //Radius
            binding.eventRadius.progress = radius
            binding.radius.text = "Radius: $radius Km"

            binding.eventRadius.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
                override fun onProgressChanged(seekBar: SeekBar?, progress: Int, fromUser: Boolean) {
                    // Update the TextView with the current progress value
                    binding.radius.text = "Radius: $progress Km"
                    radius = progress
                }

                override fun onStartTrackingTouch(seekBar: SeekBar?) {
                    // Do nothing
                }

                override fun onStopTrackingTouch(seekBar: SeekBar?) {
                    // Do nothing
                }
            })

            //duration
            binding.eventDuration.progress = duration
            binding.duration.text = "Duration: $duration H"

            binding.eventDuration.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
                override fun onProgressChanged(seekBar: SeekBar?, progress: Int, fromUser: Boolean) {
                    // Update the TextView with the current progress value
                    binding.duration.text = "Duration: $progress H"
                    duration = progress
                }

                override fun onStartTrackingTouch(seekBar: SeekBar?) {}
                override fun onStopTrackingTouch(seekBar: SeekBar?) {}
            })


            //participants
            binding.eventParticipants.progress = participants
            binding.participants.text = "Participants: $participants"

            binding.eventParticipants.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
                override fun onProgressChanged(seekBar: SeekBar?, progress: Int, fromUser: Boolean) {
                    // Update the TextView with the current progress value
                    binding.participants.text = "Participants: $progress"
                    participants = progress
                }

                override fun onStartTrackingTouch(seekBar: SeekBar?) {}
                override fun onStopTrackingTouch(seekBar: SeekBar?) {}
            })
            binding.butCreateEvent.setOnClickListener {
                if(binding.eventName.text.toString().isEmpty()){
                    binding.eventName.setError("Please type a name")
                }
                if(!(binding.eventName.text.toString().isEmpty())) {
                    val eventName = binding.eventName.text.toString()
                    val radius = radius.toDouble()
                    val duration = duration.toDouble()
                    val totalParticipants = participants.toInt()
                    val randomKey = database!!.reference.push().key
                    val event = Event(eventName, randomKey!!, FirebaseAuth.getInstance().uid!!, radius, latlng, duration, totalParticipants)
                    database!!.reference
                        .child("events")
                        .child(randomKey!!)
                        .setValue(event)
                        .addOnCompleteListener {
                            view?.findNavController()?.navigate(R.id.action_createEvent_to_mapsFragment)
                        }
                }
            }
        }
    }

    override fun onCreateOptionsMenu(menu: Menu, inflater: MenuInflater) {
        super.onCreateOptionsMenu(menu, inflater)
        inflater.inflate(R.menu.toolbar_menu,menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return NavigationUI.onNavDestinationSelected(item, requireView().findNavController())
                || super.onOptionsItemSelected(item)
    }
}