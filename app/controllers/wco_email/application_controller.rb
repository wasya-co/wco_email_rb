
require 'ish_models'

class WcoEmail::ApplicationController < ActionController::Base

  check_authorization
  before_action :current_profile

  def home
    authorize! :index, WcoEmail::Conversation

    render layout: 'wco_email/application2'
  end

  ##
  ## private
  ##
  private

  def current_profile
    @current_profile ||= Wco::Profile.find_by( email: current_user.email )
  end

end
