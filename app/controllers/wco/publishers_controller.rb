
class Wco::PublishersController < WcoEmail::ApplicationController

  layout '/wco_email/application2'

  def index
    authorize! :index, Wco::Publisher
    @publishers = Wco::Publisher.all
  end

  def new
    authorize! :new, Wco::Publisher
    @new_publisher = Wco::Publisher.new
    @sites_list = Wco::Site.list
  end

end
