class Theme < ApplicationRecord
  has_many :images, dependent: :destroy
end