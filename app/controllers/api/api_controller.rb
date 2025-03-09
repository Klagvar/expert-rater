module Api
  class ApiController < ApplicationController
    include WorkImage # Подключаем модуль с логикой работы с изображениями

    # Метод для получения следующего изображения
    def next_image
      process_navigation(:next)
    end

    # Метод для получения предыдущего изображения
    def prev_image
      process_navigation(:prev)
    end

    private

    # Общая логика обработки навигации
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

    # Подготовка данных для JSON-ответа
    def prepare_response(image_data, index)
      {
        theme: image_data[:theme],
        new_image_index: index,
        name: image_data[:name],
        file: image_data[:file],
        image_id: image_data[:image_id],
        user_valued: image_data[:user_valued],
        common_ave_value: image_data[:common_ave_value],
        value: image_data[:value],
        status: :success,
        notice: 'Success'
      }
    end

    # Логика расчета индексов
    def next_index(index, length)
      index < length - 1 ? index + 1 : 0
    end

    def prev_index(index, length)
      index > 0 ? index - 1 : length - 1
    end
  end
end