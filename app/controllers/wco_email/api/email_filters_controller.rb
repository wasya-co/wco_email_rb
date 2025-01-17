
class WcoEmail::Api::EmailFiltersController < WcoEmail::ApiController

  def create
    authorize! :create, WcoEmail::EmailFilter
    @item = ::WcoEmail::EmailFilter.new params[:email_filter].permit({
      actions: [ :kind, :value ],
      conditions: [ :field, :value ],
      skip_conditions: [ :field, :value ],
    })

    if @item.save
      render json: { status: :ok }
    else
      render json: { messages: @item.errors.full_messages, status: :not_ok }
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


end

