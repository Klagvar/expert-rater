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

  scope :popular, -> { where("ave_value > ?", 70) }
  delegate :name, to: :theme, prefix: true

  scope :theme_images, -> (theme_id) {
    select('id', 'name', 'file', 'ave_value')
      .where(theme_id: theme_id)
      .order(:id)
  }

  def next_in_theme
    self.class.where("id > ? AND theme_id = ?", id, theme_id)
        .order(:id)
        .first
  end

  def previous_in_theme
    self.class.where("id < ? AND theme_id = ?", id, theme_id)
        .order(id: :desc)
        .first
  end

  # Оставляем как вспомогательный метод
  def update_ave_value
    avg = values.average(:value)&.round(1)
    update_column(:ave_value, avg) unless avg.nil?
  end
end