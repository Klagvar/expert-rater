module WorkHelper
  def image_data(theme, data)
    @image_data = {
      theme: data[:theme] || theme,
      values_qty: data[:values_qty],
      current_user_id: data[:current_user_id],
      theme_id: data[:theme_id],
      index: data[:index],
      images_arr_size: data[:images_arr_size],
      image_id: data[:image_id],
      name: data[:name],
      file: data[:file],
      user_valued: data[:user_valued],
      value: data[:value],
      common_ave_value: data[:common_ave_value]
    }
  end
end