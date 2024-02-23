package com.bugrahankaramollaoglu.gojo

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.ImageView
import android.widget.TextView

class OptionsAdapter(private val context: Context, private val dataList: List<Option>) :
    BaseAdapter() {

    override fun getCount(): Int {
        return dataList.size
    }

    override fun getItem(position: Int): Any {
        return dataList[position]
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
        var view = convertView
        val holder: ViewHolder

        if (view == null) {
            view = LayoutInflater.from(context).inflate(R.layout.list_item, parent, false)
            holder = ViewHolder()
            holder.optionsImage = view.findViewById(R.id.optionsImage)
            holder.optionsText = view.findViewById(R.id.optionsText)
            holder.optionsArrow = view.findViewById(R.id.optionsArrow)
            view.tag = holder
        } else {
            holder = view.tag as ViewHolder
        }

        val currentItem = dataList[position]

        // Populate your views with data from currentItem
        holder.optionsText.text = currentItem.text
        holder.optionsImage.setImageResource(currentItem.image)
        holder.optionsArrow.setImageResource(currentItem.arrowImage)

        return view!!
    }

    private class ViewHolder {
        lateinit var optionsImage: ImageView
        lateinit var optionsText: TextView
        lateinit var optionsArrow: ImageView
    }
}
