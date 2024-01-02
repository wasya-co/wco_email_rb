

class WcoEmail::ObfuscatedRedirectsController < WcoEmail::ApplicationController

  def show
    @obf = Office::ObfuscatedRedirect.find params[:id]
    # puts! @obf, '@obf'
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


