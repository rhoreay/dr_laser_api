class Api::V1::Auth::RegistrationsController < ApplicationController
  allow_unauthenticated_access only: :create

  # POST /api/v1/auth/register
  def create
    user = User.new(user_params)

    if user.save
        session_record = user.sessions.create!(
          user_agent: request.user_agent,
          ip_address: request.remote_ip,
          expires_at: 30.days.from_now
        )

        access_token = JwtService.encode(user_id: user.id)

        render_success(
          data: {
            user: {
              id: user.id,
              username: user.username,
              email_address: user.email_address
            },
            access_token: access_token,
            refresh_token: session_record.refresh_token,
            expires_at: 15.minutes.to_i
          },
          message: "New user registered",
          status: :created
        )
    else
      render_error(
        errors: user.errors.full_messages,
        message: "Validation failed",
        status: :unprocessable_entity
      )
    end
  end

  def user_params
    params.require(:user).permit(:username, :email_address, :password)
  end
end
