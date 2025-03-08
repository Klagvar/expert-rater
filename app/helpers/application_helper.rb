module ApplicationHelper
  def image_orientation(file_path)
    image = MiniMagick::Image.new(Rails.root.join('app/assets/images/pictures', file_path))
    image.width >= image.height ? 'landscape' : 'portrait'
  rescue
    'landscape'
  end
end
