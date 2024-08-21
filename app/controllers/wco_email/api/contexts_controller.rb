
class WcoEmail::Api::ContextsController < WcoEmail::ApiController

  # before_action :set_lists


  def summary
    authorize! :summary, WcoEmail::Context
    @results = WcoEmail::Context.summary
  end


  ##
  ## Private
  ##
  private

  # def set_lists
  #   @email_layouts_list   = WcoEmail::EmailTemplate::LAYOUTS
  #   @email_templates_list = [ [nil, nil] ] + WcoEmail::EmailTemplate.all.map { |tmpl| [ tmpl.slug, tmpl.id ] }
  #   @leads_list           = Wco::Lead.list
  # end



end

