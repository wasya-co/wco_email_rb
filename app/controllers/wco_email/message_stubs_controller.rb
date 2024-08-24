
class WcoEmail::MessageStubsController < WcoEmail::ApplicationController

  def churn
    @stub = WcoEmail::MessageStub.find params[:id]
    authorize! :churn, @stub

    # WcoEmail::MessageIntakeJob.perform_async( @stub.id.to_s )
    begin
      @stub.do_process
    rescue => err
      @stub.update({ status: WcoEmail::MessageStub::STATUS_FAILED })
      puts! err, "WcoEmail::MessageIntakeJob error"
      ::ExceptionNotifier.notify_exception(
        err,
        data: { stub: @stub }
      )
    end

    flash_notice "Churned 1 stub."
    redirect_to request.referrer
  end

  def create
    @stub = WcoEmail::MessageStub.new params[:stub].permit!
    authorize! :create, @stub
    if @stub.save
      flash_notice 'saved.'
      redirect_to action: 'show'
    else
      flash_alert "Cannot save stub: #{@stub.errors.full_messages}"
      render 'new'
    end
  end

  def edit
    @stub = WcoEmail::MessageStub.find params[:id]
    authorize! :edit, @stub
  end

  def index
    authorize! :index, WcoEmail::MessageStub
    @stubs = WcoEmail::MessageStub.all.page( params[:stubs_page] )
    render '_index_table'
  end

  def new
    @stub = WcoEmail::MessageStub.new
    authorize! :new, @stub
  end

  def show
    @stub = WcoEmail::MessageStub.find params[:id]
    authorize! :show, @stub
  end

  def update
    @stub = WcoEmail::MessageStub.find params[:id]
    authorize! :update, @stub
    flag = @stub.update_attributes params[:stub].permit!
    if flag
      flash_notice 'success'
      redirect_to action: 'show'
    else
      flash_alert "Cannot save stub: #{@stub.errors.full_messages}"
      render 'edit'
    end
  end

end

