module WorkImage
  extend ActiveSupport::Concern

  def show_image(theme_id, image_index)
    theme = Theme.find(theme_id)
    theme_images = theme.images.order(:id)
    current_image = theme_images[image_index]

    # Получаем текущую оценку пользователя и среднюю оценку
    user_score = signed_in? ? current_user.values.find_by(image_id: current_image.id)&.value || 0 : 0
    ave_value = current_image.ave_value || 0

    {
      theme_id: theme.id,
      index: image_index,
      images_arr_size: theme_images.size,
      theme: theme.name,
      name: current_image.name,
      file: current_image.file,
      image_id: current_image.id,
      user_score: user_score, # Добавляем оценку пользователя
      ave_value: ave_value    # Добавляем среднюю оценку
    }
  end

  private

end