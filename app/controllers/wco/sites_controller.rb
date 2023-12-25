
class Wco::SitesController < Wco::ApplicationController

  def create
    @site = Wco::Site.new params[:site].permit!
    authorize! :create, @site
    if @site.save
      flash_notice "created site"
    else
      flash_alert "Cannot create site: #{@site.errors.messages}"
    end
    redirect_to action: 'index'
  end

  def destroy
    @site = Wco::Site.find params[:id]
    authorize! :destroy, @site
    if @site.destroy
      flash_notice 'ok'
    else
      flash_alert 'No luck.'
    end
    redirect_to action: 'index'
  end

  def index
    authorize! :index, Wco::Site
    @sites = Wco::Site.all
  end

  def new
    authorize! :new, Wco::Site
    @new_site = Wco::Site.new

  end

end
