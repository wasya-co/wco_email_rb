
class WcoEmail::Api::EmailTemplatesController < WcoEmail::ApiController

  def index
    authorize! :index, WcoEmail::EmailTemplate
    @items = WcoEmail::EmailTemplate.all
  end


end

