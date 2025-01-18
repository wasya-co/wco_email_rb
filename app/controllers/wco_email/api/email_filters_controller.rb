
class WcoEmail::Api::EmailFiltersController < WcoEmail::ApiController

  def create
    authorize! :create, WcoEmail::EmailFilter
    @item = ::WcoEmail::EmailFilter.new params[:email_filter].permit({
      actions_attributes:         [ :kind,              :value ],
      conditions_attributes:      [ :field, :matchtype, :value ],
      skip_conditions_attributes: [ :field, :matchtype, :value ],
    })

    if @item.save
      render json: { id: @item.id.to_s }, status: :ok
    else
      render json: { messages: @item.errors.full_messages }, status: 400
    end
  end

  def index
    authorize! :index, WcoEmail::EmailFilter
    @items = ::WcoEmail::EmailFilter.all
    # respond_to do |format|
    #   format.json do
    #     render
    #   end
    # end
  end

  def show
    @filter = WcoEmail::EmailFilter.find params[:id]
    authorize! :show, @filter
  end

end

