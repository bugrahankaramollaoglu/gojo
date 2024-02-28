package com.bugrahankaramollaoglu.gojo

import android.content.Context
import android.graphics.Typeface
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.res.ResourcesCompat

class OptionsAdapter(
    private val context: Context,
    private val dataList: List<Option>,
    private var currentFont: String?,
    private var currentTheme: String?,
    private var currentNotification: Boolean
) :
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

        holder.optionsText.text = currentItem.text

        val typeface: Typeface? = when {
            currentFont!!.isNotBlank() -> {
                val fontResId =
                    context.resources.getIdentifier(currentFont, "font", context.packageName)
                ResourcesCompat.getFont(context, fontResId)
            }

            else -> null
        }

        typeface?.let { it ->
            holder.optionsText.typeface = it
        }

        if (currentItem == dataList[1]) {
            if (currentTheme.equals("dark")) {
                holder.optionsImage.setImageResource(R.drawable.baseline_dark_mode_24)
            } else {
                holder.optionsImage.setImageResource(R.drawable.light_theme)
            }
        } else {
            holder.optionsImage.setImageResource(currentItem.image)
        }

        holder.optionsImage.setImageResource(currentItem.image)
        holder.optionsArrow.setImageResource(currentItem.arrowImage)

        return view!!
    }

    fun updateFont(fontName: String?) {
        currentFont = fontName
        notifyDataSetChanged()
    }

    fun updateThemeIcon(currentTheme: String?) {
        for (item in dataList) {
            if (item.text == "Temayı Değiştir") {
                if (currentTheme.equals("dark")) {
                    item.image = R.drawable.light_theme
                } else {
                    item.image = R.drawable.baseline_dark_mode_24
                }
            }
        }
        notifyDataSetChanged()
    }

    fun updateNotification(currentNotification: Boolean) {

    }


    private class ViewHolder {
        lateinit var optionsImage: ImageView
        lateinit var optionsText: TextView
        lateinit var optionsArrow: ImageView
    }
}
