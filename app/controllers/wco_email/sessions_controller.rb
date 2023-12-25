
class WcoEmail::SessionsController < Wco::ApplicationController

  skip_before_action :verify_authenticity_token, only: :create

  def new
    render :new
  end

  def create
    puts! params, '#create'

    user_info = request.env['omniauth.auth']
    puts! user_info, 'user_info'

    render json: { status: :ok }
  end

end
