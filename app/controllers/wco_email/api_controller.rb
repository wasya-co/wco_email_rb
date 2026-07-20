
class WcoEmail::ApiController < ActionController::Base

  skip_before_action :verify_authenticity_token
  layout false


  ##
  ## private
  ##
  private

  def check_credentials
    if params[:secret] != AWS_SES_LAMBDA_SECRET
      render status: 400, json: { status: 400, message: "#check_credentials in wco_email says unauthorized." }
      return
    end
  end

  def current_profile
    Wco::Profile.find_by email: current_user.email
  end

  def decode_jwt
    if Rails.env.test?
      sign_in User.find_by({ email: 'victor@wasya.co' })
      return
    end

    out = JWT.decode params[:jwt_token], nil, false
    email = out[0]['email']
    user = User.find_by({ email: email })
    puts! user, 'user'

    sign_in user
  end

end
