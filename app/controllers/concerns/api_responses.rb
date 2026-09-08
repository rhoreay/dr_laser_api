module ApiResponses
  extend ActiveSupport::Concern

  def render_success(data: {}, message: "Operation realized", status: :ok)
    render json: {
      success: true,
      message: message,
      data: data,
      timestamp: Time.current.iso8601
    }, status: status
  end

  def render_error(errors: {}, message: "Operation failed", status: :unprocessable_entity)
    render json: {
      succcess: false,
      message: message,
      errors: errors,
      timestamp: Time.current.iso8601
    }, status: status
  end
end
