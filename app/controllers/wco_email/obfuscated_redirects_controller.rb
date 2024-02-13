

class WcoEmail::ObfuscatedRedirectsController < WcoEmail::ApplicationController

  def show
    @obf = WcoEmail::ObfuscatedRedirect.find params[:id]
    authorize! :show, @obf
    visit_time = Time.now
    @obf.update_attributes({
      visited_at: visit_time,
      visits: @obf.visits + [ visit_time ],
    })
    # render and return if DEBUG
    redirect_to @obf.to
  end

end


