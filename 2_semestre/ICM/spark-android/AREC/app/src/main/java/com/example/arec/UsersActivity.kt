package com.example.arec

import android.os.Bundle
import android.view.*
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import androidx.navigation.fragment.findNavController
import androidx.navigation.ui.NavigationUI
import androidx.recyclerview.widget.GridLayoutManager
import com.example.arec.adapter.UserAdapter
import com.example.arec.databinding.UsersBinding
import com.example.arec.model.User
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ValueEventListener


class UsersActivity : Fragment() {

    var binding: UsersBinding? = null
    var database: FirebaseDatabase? = null
    var users: ArrayList<User>? = null
    var usersAdapter: UserAdapter? = null
    var userLogged: User? = null

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        binding = DataBindingUtil.inflate<UsersBinding>(inflater, R.layout.users,container,false)
        database = FirebaseDatabase.getInstance()
        users = ArrayList<User>()
        usersAdapter = UserAdapter(requireContext(), users!!, findNavController())
        val layoutManager = GridLayoutManager(requireContext(), 2)
        binding!!.mRec.layoutManager = layoutManager
        database!!.reference.child("users")
            .child(FirebaseAuth.getInstance().uid!!)
            .addValueEventListener(object :ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    userLogged = snapshot.getValue(User::class.java)
                }

                override fun onCancelled(error: DatabaseError) {}

            })
        binding!!.mRec.adapter = usersAdapter
        database!!.reference.child("users").addValueEventListener(object : ValueEventListener{
            override fun onDataChange(snapshot: DataSnapshot) {
                users!!.clear()
                for(snapshot1 in snapshot.children) {
                    val user: User? = snapshot1.getValue(User::class.java)
                    if(!(user!!.uid.equals(FirebaseAuth.getInstance().uid)) and userLogged!!.matched.contains(user.uid!!) )
                        users!!.add(user)
                }
                usersAdapter!!.notifyDataSetChanged()
            }

            override fun onCancelled(error: DatabaseError) {}

        })
        setHasOptionsMenu(true)
        return binding!!.root
    }

    override fun onResume() {
        super.onResume()
        val currentId = FirebaseAuth.getInstance().uid
        database!!.reference.child("presence")
            .child(currentId!!).setValue("Online")
    }

    override fun onPause() {
        super.onPause()
        val currentId = FirebaseAuth.getInstance().uid
        database!!.reference.child("presence")
            .child(currentId!!).setValue("offline ")
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