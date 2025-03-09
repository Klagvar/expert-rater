module WorkImage
  extend ActiveSupport::Concern

  def show_image(theme_id, image_index)
    theme = Theme.find(theme_id)
    theme_images = theme.images.order(:id)
    current_image = theme_images[image_index]

    {
      theme_id: theme.id,
      index: image_index,
      images_arr_size: theme_images.size,
      theme: theme.name,
      name: current_image.name,
      file: current_image.file,
      image_id: current_image.id
    }
  end

  private

end