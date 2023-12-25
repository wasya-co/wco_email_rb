
class Wco::PublishersController < WcoEmail::ApplicationController

  def index
    authorize! :index, Wco::Publisher
  end

end
