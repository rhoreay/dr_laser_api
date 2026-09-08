class Api::V1::Auth::SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ create refresh ]

  def new
  end

  # POST api/v1/login
  def create
    user = User.authenticate_by(email_address: params[:email_address], password: params[:password])

    if user
      session_recorded = user.sessions.create!(
        user_agent: request.user_agent,
        ip_address: request.remote_ip,
        expires_at: 30.days.from_now
      )

      access_token = JwtService.encode(
        user_id: user.id
      )

      render_success(
        data: {
          access_token: access_token,
          refresh_token: session_recorded.refresh_token,
          expires_at: 15.minutes.to_i
        },
        message: "Login completed",
        status: :created
      )
    else
      render_error(
        errors: [ "Invalid credentials" ],
        status: :unauthorized
        )
    end
  end

  # POST api/v1/refresh
  def refresh
    token = params[:refresh_token]
    session_record = Session.where("expires_at > ?", Time.current()).find_by(refresh_token: token)

    if session_record
      session_record.regenerate_refresh_token
      session_record.update!(expires_at: 30.days.from_now)

      access_token = JwtService.encode(user_id: session_record.user_id)

      render_success(
        data: {
          access_token: access_token,
          refresh_token: session_record.refresh_token,
          expires_at: 15.minutes.to_i
        },
        message: "Token refreshed"
      )
    else
      render_error(
        errors: [ "Invalid or expired token" ]
      )
    end
  end

  # DELETE api/v1/logout
  def destroy
    session_record = Session.find_by(refresh_token: params[:refresh_token])

    if session_record&.destroy
      render_success(
        message: [ "Logout completed" ]
      )
    else
      render_error(
        errors: [ "Session not found" ],
        status: :not_found
      )
    end
  end
end
