
class WcoEmail::ApiController < ActionController::Base

  before_action      :check_credentials, only: [ :create_email_message ]
  before_action      :decode_jwt,      except: [ :create_email_message ]
  skip_before_action :verify_authenticity_token
  layout false

  def create_email_message
    # puts! params, 'params'

    stub = WcoEmail::MessageStub.find_or_create_by({
      bucket:     params[:bucket],
      object_key: params[:object_key],
    })

    WcoEmail::MessageIntakeJob.perform_async( stub.id.to_s )
    render status: :ok, json: { status: :ok }
  end

  ##
  ## private
  ##
  private

  def check_credentials
    if params[:secret] != AWS_SES_LAMBDA_SECRET
      render status: 400, json: { status: 400, message: "#check_credentials says unauthorized." }
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
