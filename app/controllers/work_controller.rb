class WorkController < ApplicationController
  include WorkImage

  def index
    @selected_theme = "Выберите тему"
    @values_qty = Value.count
    session[:selected_theme_id] = nil
    @image_data = default_data
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

    # Критически важно обновить @image_data[:id] для кнопок!
    respond_to do |format|
      format.js {
        render 'display_theme',
               locals: { image_id: @image_data[:id] }
      }
    end
  end

  def process_theme(theme_name)
    return default_data if theme_name.blank?

    theme = Theme.order(:id).find_by(name: theme_name.strip)
    return default_data unless theme

    # Возвращаем полные данные для API
    {
      theme_id: theme.id,
      index: 0,
      images_arr_size: theme.images.count,
      id: theme.images.first&.id || 0,
      file: theme.images.first&.file || 'sponge_bob_1.jpg',
      name: theme.images.first&.name || 'Спанги бобе додеп',
      theme: theme.name
    }
  end

  private

  def default_data
    {
      id: 0, # Заглушка для избежания nil
      file: 'sponge_bob_1.jpg',
      name: 'Спанги бобе додеп',
      theme: "Выберите тему"
    }
  end
end