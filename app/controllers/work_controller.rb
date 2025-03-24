class WorkController < ApplicationController
  include WorkImage
  skip_forgery_protection only: :choose_theme
  def index
    @selected_theme = "Выберите тему"
    @values_qty = Value.count
    session[:selected_theme_id] = nil
    @image_data = default_data
    # Добавляем начальные значения для рейтинга
    @image_data[:user_score] = 0
    @image_data[:ave_value] = 0
  end

  def choose_theme
    @themes = Theme.order(:id).pluck(:name)
    respond_to do |format|
      format.js # Будет искать choose_theme.js.erb
      format.html { redirect_to root_path }
    end
  end

  def display_theme
    @image_data = process_theme(params[:theme])
    session[:selected_theme_id] = Theme.find_by(name: params[:theme])&.id
    # Добавляем текущую оценку пользователя и среднюю оценку
    if @image_data[:id] > 0 && signed_in?
      user_value = current_user.values.find_by(image_id: @image_data[:id])
      @image_data[:user_score] = user_value&.value || 0
      @image_data[:ave_value] = Image.find(@image_data[:id]).ave_value || 0
    else
      @image_data[:user_score] = 0
      @image_data[:ave_value] = 0
    end

    respond_to do |format|
      format.js { render 'display_theme', locals: { image_id: @image_data[:id] } }
    end
  end

  def process_theme(theme_name)
    return default_data if theme_name.blank?

    theme = Theme.order(:id).find_by(name: theme_name.strip)
    return default_data unless theme

    first_image = theme.images.first
    {
      theme_id: theme.id,
      index: 0,
      images_arr_size: theme.images.count,
      id: first_image&.id || 0,
      file: first_image&.file || 'sponge_bob_1.jpg',
      name: first_image&.name || 'Спанги бобе додеп',
      theme: theme.name,
      user_score: 0, # Начальное значение
      ave_value: first_image&.ave_value || 0 # Средняя оценка из модели
    }
  end

  private

  def default_data
    {
      id: 0,
      file: 'placeholder.jpg',
      name: nil,
      theme: "Выберите тему",
      user_score: 0,
      ave_value: 0
    }
  end
end