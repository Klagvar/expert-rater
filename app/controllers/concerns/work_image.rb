module WorkImage
  extend ActiveSupport::Concern

  def show_image(theme_id, index)
    theme_images = Image.theme_images(theme_id)
    current_image = theme_images[index]

    {
      index: index,
      name: current_image.name,
      file: current_image.file,
      theme_id: theme_id,
      images_arr_size: theme_images.size
    }
  end
end