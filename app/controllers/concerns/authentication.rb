module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
    helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :authenticate_request!, **options
    end
  end

  private

  def authenticate_request!
    token = extract_token_from_header
    payload = JwtService.decode(token)

    case payload
    when :expired
      render json: { error: "Expired token" }, status: unauthorized
    when Hash
      if (user = User.find_by(id: payload[:user_id]))
        Current.user = user
      else
        render json: { error: "User not found" }, status: unauthorized
      end
    else
      render json: { error: "Unauthorized" }, status: unauthorized
    end
  end

  def authenticated?
    Current.user.present?
  end

  def extract_token_from_header
    header = request.headers["Authorization"]
    header&.split(" ")&.last if header&.start_with?("Bearer ")
  end
end
