module Api
  class ApiController < ApplicationController
    include WorkImage

    def next_image
      process_navigation(:next)
    end

    def prev_image
      process_navigation(:prev)
    end

    def rate_image
      return render json: { status: :unauthorized, notice: 'Войдите в систему' }, status: :unauthorized unless signed_in?

      image = Image.find(params[:image_id])
      score = params[:score].to_i

      # Создаём или обновляем оценку пользователя
      value = current_user.values.find_or_initialize_by(image: image)
      value.value = score
      if value.save
        # Пересчитываем среднюю оценку (это уже есть в Image#after_save)
        image.reload
        render json: {
          status: :success,
          notice: 'Оценка сохранена',
          user_score: value.value,
          ave_value: image.reload.ave_value || 0
        }
      else
        render json: { status: :error, notice: value.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end

    private

    def process_navigation(direction)
      current_index = params[:index].to_i
      theme_id = params[:theme_id].to_i
      length = params[:length].to_i

      new_index = direction == :next ? next_index(current_index, length) : prev_index(current_index, length)
      image_data = show_image(theme_id, new_index)

      respond_to do |format|
        format.json { render json: prepare_response(image_data, new_index) }
      end
    end

    def prepare_response(image_data, index)
      {
        theme: image_data[:theme],
        new_image_index: index,
        name: image_data[:name],
        file: image_data[:file],
        image_id: image_data[:image_id],
        user_score: image_data[:user_score],
        ave_value: image_data[:ave_value],
        status: :success,
        notice: 'Success'
      }
    end

    def next_index(index, length)
      index < length - 1 ? index + 1 : 0
    end

    def prev_index(index, length)
      index > 0 ? index - 1 : length - 1
    end
  end
end