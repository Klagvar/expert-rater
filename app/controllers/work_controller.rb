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

  def next_image
    @image = Image.find(params[:image_id])
    @next_image = @image.next_in_theme
    respond_to :js
  end

  def previous_image
    @image = Image.find(params[:image_id])
    @previous_image = @image.previous_in_theme
    respond_to :js
  end



  def process_theme(theme_name)
    return default_data if theme_name.blank?

    # Явная проверка порядка тем через сортировку
    theme = Theme.order(:id).find_by(name: theme_name.strip)
    return default_data unless theme

    # Жёсткая проверка привязки изображений к теме
    image = theme.images.order(:id).first
    return default_data unless image

    {
      id: image.id,
      file: image.file,
      name: image.name,
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