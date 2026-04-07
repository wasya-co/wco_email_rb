
class WcoEmail::ConfigsController < WcoEmail::ApplicationController
  before_action :set_config, only: %i[show edit update destroy]

  def index
    @configs = WcoEmail::Config.all
    authorize! :index, WcoEmail::Config
  end

  def show
    authorize! :index, WcoEmail::Config
  end

  def new
    @config = WcoEmail::Config.new
    authorize! :index, WcoEmail::Config
  end

  def edit
    authorize! :index, WcoEmail::Config
  end

  def create
    @config = WcoEmail::Config.new(config_params)
    authorize! :index, WcoEmail::Config

    if @config.save
      flash[:notice] = 'Success.'
      redirect_to action: 'index'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize! :index, WcoEmail::Config
    if @config.update(config_params)
      flash[:notice] = 'Success.'
      redirect_to action: 'index'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :index, WcoEmail::Config
    @config.destroy
    redirect_to action: 'index'
  end

  ##
  ## private
  ##
  private

  def set_config
    @config = WcoEmail::Config.find(params[:id])
  rescue Mongoid::Errors::DocumentNotFound
    redirect_to wco_email.configs_path, alert: 'Config not found'
  end

  def config_params
    params.require(:config).permit(:key, :value, :descr)
  end
end