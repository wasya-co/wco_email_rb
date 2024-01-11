
class WcoEmail::ApiController < ActionController::Base

  before_action :check_credentials

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
