class JwtService
  SECRET_KEY = Rails.application.credentials.secret_key_base

  def self.encode(payload, exp = 15.minutos.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: "HS256" })
    ActiveSupport::HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature
    :expired
  rescue JWT::DecodeError
    nil
  end
end
