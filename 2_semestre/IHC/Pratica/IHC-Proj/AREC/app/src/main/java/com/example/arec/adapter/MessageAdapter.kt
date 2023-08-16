package com.example.arec.adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.example.arec.R
import com.example.arec.model.Message
import com.google.firebase.auth.FirebaseAuth

class MessageAdapter(val context: Context, val messageList: ArrayList<Message>): RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    val ITEM_RECEIVED = 1
    val ITEM_SENT = 2

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        if(viewType == 1) {
            val view: View = LayoutInflater.from(context).inflate(R.layout.received, parent, false)
            return ReceivedViewHolder(view)
        } else {
            val view: View = LayoutInflater.from(context).inflate(R.layout.sent, parent, false)
            return SentViewHolder(view)
        }

    }

    override fun getItemCount(): Int {
        return messageList.size
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        val currentMessage = messageList[position]

        if(holder.javaClass == SentViewHolder::class.java) {
            val viewHolder = holder as SentViewHolder

            if(currentMessage.message.equals("photo")) {

                viewHolder.sentImage.visibility = View.VISIBLE
                viewHolder.sentMessage.visibility = View.GONE
                Glide.with(context)
                    .load(currentMessage.imageUrl)
                    .placeholder(R.drawable.placeholder)
                    .into(viewHolder.sentImage)
            } else {
                viewHolder.sentImage.visibility = View.GONE
                viewHolder.sentMessage.visibility = View.VISIBLE
                viewHolder.sentMessage.text = currentMessage.message
            }

        } else {
            val viewHolder =  holder as ReceivedViewHolder

            if(currentMessage.message.equals("photo")) {

                viewHolder.receivedImage.visibility = View.VISIBLE
                viewHolder.receivedMessage.visibility = View.GONE
                Glide.with(context)
                    .load(currentMessage.imageUrl)
                    .placeholder(R.drawable.placeholder)
                    .into(viewHolder.receivedImage)
            } else {
                viewHolder.receivedImage.visibility = View.GONE
                viewHolder.receivedMessage.visibility = View.VISIBLE
                viewHolder.receivedMessage.text = currentMessage.message
            }

        }
    }

    override fun getItemViewType(position: Int): Int {
        val currentMessage = messageList[position]

        if(FirebaseAuth.getInstance().currentUser?.uid.equals(currentMessage.senderId)) {
            return ITEM_SENT
        } else {
            return ITEM_RECEIVED
        }
    }


    class SentViewHolder(itemView: View): RecyclerView.ViewHolder(itemView) {
        val sentMessage = itemView.findViewById<TextView>(R.id.txt_sent_message)
        val sentImage = itemView.findViewById<ImageView>(R.id.image_sent)
    }

    class ReceivedViewHolder(itemView: View): RecyclerView.ViewHolder(itemView) {
        val receivedMessage = itemView.findViewById<TextView>(R.id.txt_received_message)
        val receivedImage = itemView.findViewById<ImageView>(R.id.image_received)

    }
}