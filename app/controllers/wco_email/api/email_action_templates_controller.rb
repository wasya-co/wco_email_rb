
class WcoEmail::Api::EmailActionTemplatesController < WcoEmail::ApiController

  def index
    authorize! :index, WcoEmail::EmailAction
    @items = WcoEmail::EmailActionTemplate.all
  end


end

