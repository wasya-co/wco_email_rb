
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


end

