package com.example.arec

import android.os.Bundle
import android.view.*
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import androidx.navigation.ui.NavigationUI
import com.example.arec.databinding.TurtorialBinding

class Turtorial : Fragment() {

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val binding = DataBindingUtil.inflate<TurtorialBinding>(inflater, R.layout.turtorial,container,false)

        binding.butJoin .setOnClickListener {view : View ->
            view?.findNavController()?.navigate(R.id.action_turtorial_to_maps)
        }
        return binding.root
    }
}