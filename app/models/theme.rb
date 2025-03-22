class Theme < ApplicationRecord
  has_many :images, dependent: :destroy

  def best_image
    images.order(ave_value: :desc).first
  end
end