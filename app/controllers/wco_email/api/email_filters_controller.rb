
class WcoEmail::Api::EmailFiltersController < WcoEmail::ApiController

  def create
    authorize! :create, WcoEmail::EmailFilter
    @item = ::WcoEmail::EmailFilter.new params[:email_filter].permit!

    if @item.save
      render json: { status: :ok }
    else
      render json: { messages: @item.errors.full_messages, status: :not_ok }
    end
  end

end

