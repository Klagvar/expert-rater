class User < ApplicationRecord
  has_secure_password
  has_many :values, dependent: :destroy

  before_create :create_remember_token

  validates :name,
            presence: true,  # Обязательное поле
            uniqueness: true,  # Уникальность имени
            length: { maximum: 50 }

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, length: { minimum: 6 }, allow_nil: true

  # Метод для генерации нового токена
  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  # Метод для шифрования токена
  def self.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

  # Создание токена перед сохранением пользователя
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end