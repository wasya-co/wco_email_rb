
class WcoEmail::ApiController < ActionController::Base

  before_action      :check_credentials
  skip_before_action :verify_authenticity_token

  def create_email_message
    # puts! params, 'params'

    stub = WcoEmail::MessageStub.create!({
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
      render status: 400, json: { status: 400 }
      return
    end
  end

end
