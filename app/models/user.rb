class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :username, with: ->(u) { u.strip.downcase }
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }, allow_blank: true
end
