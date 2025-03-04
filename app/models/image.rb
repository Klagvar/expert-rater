class Image < ApplicationRecord
  belongs_to :theme
  has_many :values, dependent: :destroy

  validates :name,
            presence: { message: "Название обязательно" },
            length: { maximum: 200 }

  validates :file,
            presence: { message: "Файл обязателен" }

  validates :ave_value,
            numericality: {
              allow_nil: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 100
            }
  # app/models/image.rb
  scope :popular, -> { where("ave_value > ?", 70) }
  delegate :name, to: :theme, prefix: true  # для image.theme_name

  # Автоматическое обновление средней оценки
  after_save :update_ave_value

  private

  def update_ave_value
    avg = values.average(:value)
    update_column(:ave_value, avg) unless avg.nil?
  end
end