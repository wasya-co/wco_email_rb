
class WcoEmail::MessageStubsController < WcoEmail::ApplicationController

  def churn
    @stub = WcoEmail::MessageStub.find params[:id]
    authorize! :churn, @stub
    WcoEmail::MessageIntakeJob.perform_async( @stub.id.to_s )
    flash_notice "Schedueld to churn 1 stub."
    redirect_to request.referrer
  end


end

