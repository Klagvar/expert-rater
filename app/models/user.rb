class User < ApplicationRecord
  has_secure_password
  has_many :values, dependent: :destroy

  validates :name,
            length: { maximum: 50 }

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, length: { minimum: 6 }, allow_nil: true

end