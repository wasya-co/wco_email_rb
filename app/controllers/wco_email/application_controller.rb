
require 'ish_models'

class WcoEmail::ApplicationController < ActionController::Base

  check_authorization

  def home
    authorize! :index, ::Wco::EmailConversation
    render layout: 'wco_email/application2'
  end

  ##
  ## private
  ##
  private

  def current_ability
    @current_ability ||= ::WcoEmail::Ability.new(current_user)
  end

  def current_profile
    @current_profile ||= Wco::Profile.find_by( email: current_user.email )
  end

end
