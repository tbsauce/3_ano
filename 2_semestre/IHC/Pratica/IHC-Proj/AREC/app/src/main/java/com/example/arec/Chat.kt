package com.example.arec

//import kotlinx.coroutines.NonCancellable.message
import android.content.Intent
import android.os.Bundle
import android.view.*
import android.widget.EditText
import android.widget.ImageView
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import androidx.navigation.ui.NavigationUI
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.example.arec.adapter.MessageAdapter
import com.example.arec.databinding.ChatBinding
import com.example.arec.model.Message
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.*
import com.google.firebase.storage.FirebaseStorage
import java.util.*

class Chat : Fragment() {

    lateinit var binding: ChatBinding
    private lateinit var chatRecyclerView: RecyclerView
    private lateinit var messageBox: EditText
    private lateinit var sendButton: ImageView
    private lateinit var attatchmentButton: ImageView
    private lateinit var messageAdapter: MessageAdapter
    private lateinit var messageList: ArrayList<Message>
    private lateinit var database: DatabaseReference
    private lateinit var storage: FirebaseStorage

    var receiverRoom: String? = null
    var senderRoom: String? = null

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        binding = DataBindingUtil.inflate<ChatBinding>(inflater, R.layout.chat,container,false)
        val name = arguments?.getString("name")
        val receiverUid = arguments?.getString("uid")
        val image = arguments?.getString("image")

        //setup ToolBar
        binding.name.text = name
        Glide.with(requireActivity()).load(image)
            .placeholder(R.drawable.avatar)
            .into(binding.profile01)
        binding.imageView2.setOnClickListener {view : View ->
            view.findNavController().navigate(R.id.action_chatActivity_to_usersActivity)
        }

        val senderUid = FirebaseAuth.getInstance().currentUser?.uid
        database = FirebaseDatabase.getInstance().getReference()
        storage = FirebaseStorage.getInstance()

        senderRoom = receiverUid + senderUid
        receiverRoom = senderUid + receiverUid

        chatRecyclerView = binding.chatRecyclerView
        sendButton = binding.sentButton
        attatchmentButton = binding.attachmentButton
        messageBox = binding.messageBox
        messageList = ArrayList()
        messageAdapter = MessageAdapter(requireContext(),messageList)

        chatRecyclerView.layoutManager = LinearLayoutManager(requireContext())
        chatRecyclerView.adapter = messageAdapter

        database.child("chat").child(senderRoom!!).child("messages")
            .addValueEventListener(object: ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    messageList.clear()
                    for(postSnapshot in snapshot.children) {
                        val message = postSnapshot.getValue(Message::class.java)
                        messageList.add(message!!)
                    }
                    messageAdapter.notifyDataSetChanged()
                }

                override fun onCancelled(error: DatabaseError) {
                }

            })

        sendButton.setOnClickListener {
            val message = messageBox.text.toString()
            if(message != "") {
                val messageObject = Message(message, senderUid)

                database.child("chat").child(senderRoom!!).child("messages").push()
                    .setValue(messageObject).addOnSuccessListener {
                        database.child("chat").child(receiverRoom!!).child("messages").push()
                            .setValue(messageObject)
                    }
                messageBox.setText("")
            }
        }

        attatchmentButton.setOnClickListener {
            val intent = Intent()
            intent.action = Intent.ACTION_GET_CONTENT
            intent.type = "image/*"
            startActivityForResult(intent,25)
        }
        setHasOptionsMenu(true)
        return binding.root
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
        if (requestCode == 25) {
            if (data != null) {
                if (data.data != null) {
                    val selectedImage = data.data
                    val calendar = Calendar.getInstance()
                    var reference = storage!!.reference.child("chat")
                        .child(calendar.timeInMillis.toString()+"")
                    reference.putFile(selectedImage!!)
                        .addOnCompleteListener { task ->
                            if (task.isSuccessful) {
                                reference.downloadUrl.addOnSuccessListener { uri ->
                                    val filePath = uri.toString()
                                    val messageTxt :String = messageBox.text.toString()
                                    val date = Date()
                                    val message = Message(messageTxt, FirebaseAuth.getInstance().currentUser?.uid)
                                    message.message = "photo"
                                    message.imageUrl = filePath
                                    messageBox.setText("")
                                    database!!.child("chat")
                                        .child(senderRoom!!)
                                        .child("messages")
                                        .push()
                                        .setValue(message).addOnSuccessListener {
                                            database!!.child("chat")
                                                .child(receiverRoom!!)
                                                .child("messages")
                                                .push()
                                                .setValue(message)
                                                .addOnSuccessListener {  }

                                        }
                                }
                            }
                        }
                }
            }
        }
    }

}
