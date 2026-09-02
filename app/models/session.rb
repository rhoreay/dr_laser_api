class Session < ApplicationRecord
  belongs_to :user
  has_secure_token :refresh_token
  before_create :set_expiration!

  scope :active, -> { where("expires_at > ?", Time.current) }

  def expired?
    expires_at <= Time.current
  end

  private
  def set_expiration!
    self.expires_at = 30.days.from_now
  end
end
