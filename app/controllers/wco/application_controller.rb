
# require 'ish_models'

class Wco::ApplicationController < ActionController::Base

  check_authorization
  before_action :current_profile

  layout 'wco/application'

  def home
    authorize! :index, WcoEmail::Conversation
  end

  ##
  ## private
  ##
  private

  def current_profile
    @current_profile ||= Wco::Profile.find_by( email: current_user.email )
  end

  ## v0.0.0
  def flash_alert what
    flash[:alert] ||= []
    if String == what.class
      str = what
    else
      str = "Cannot create/update #{what.class.name}: #{what.errors.full_messages.join(', ')} ."
    end
    flash[:alert] << str
  end

  def flash_notice what
    flash[:notice] ||= []
    if String == what.class
      str = what
    else
      str = "Created/updated #{what.class.name} ."
    end
    flash[:notice] << str
  end

end
