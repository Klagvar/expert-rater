module ApplicationHelper
  def image_orientation(file_path)
    image = MiniMagick::Image.new(Rails.root.join('app/assets/images/pictures', file_path))
    image.width >= image.height ? 'landscape' : 'portrait'
  rescue
    'landscape'
  end

  def flag_image
    case I18n.locale
    when :ru then 'Russia.png'
    when :en then 'United_Kingdom.png'
    end
  end
end
