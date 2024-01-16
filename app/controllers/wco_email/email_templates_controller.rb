

class WcoEmail::EmailTemplatesController < WcoEmail::ApplicationController

  def create
    authorize! :create, WcoEmail::EmailTemplate
    @template = WcoEmail::EmailTemplate.create params[:template].permit!
    if @template.persisted?
      flash[:notice] = 'Success.'
    else
      flash[:alert] = "Could not create an email template: #{@template.errors.full_messages.join(', ')}."
    end
    redirect_to action: :index
  end

  def destroy
    authorize! :destroy, WcoEmail::EmailTemplate
    @template = WcoEmail::EmailTemplate.where({ id: params[:id] }).first || WcoEmail::EmailTemplate.find_by({ slug: params[:id] })
    if @template.destroy
      flash[:notice] = 'Success.'
    else
      flash[:alert] = 'Cannot destroy this template.'
    end
    redirect_to action: :index
  end

  def edit
    @tmpl = @email_template = WcoEmail::EmailTemplate.where({ id: params[:id] }).first
    authorize! :edit, @tmpl
  end

  def iframe_src
    @tmpl = @email_template = WcoEmail::EmailTemplate.where({ id: params[:id] }).first ||
      WcoEmail::EmailTemplate.find_by({ slug: params[:id] })
    authorize! :iframe_src, @email_template

    @lead        = Lead.find_by({ email: 'poxlovi@gmail.com' })
    @ctx         = Ctx.new({ email_template: @tmpl, lead_id: @lead.id })
    @tmpl_config = OpenStruct.new JSON.parse( @ctx.tmpl[:config_json] )

    @utm_tracking_str = {
      'cid'          => @ctx.lead_id,
      'utm_campaign' => @ctx.tmpl.slug,
      'utm_medium'   => 'email',
      'utm_source'   => @ctx.tmpl.slug,
    }.map { |k, v| "#{k}=#{v}" }.join("&")

    @unsubscribe_url = WcoEmail::Engine.routes.url_helpers.unsubscribes_url({
      template_id: @ctx.tmpl.id,
      lead_id:     @lead.id,
      token:       @lead.unsubscribe_token,
    })

    render layout: false
  end

  def index
    authorize! :index, WcoEmail::EmailTemplate
    @templates = WcoEmail::EmailTemplate.all

    if params[:q]
      q = URI.decode(params[:q])
      @templates = @templates.where({ :slug => /#{q}/i })
    end

    @templates = @templates.order_by( slug: :asc )

    if '_index_expanded' == params[:view]
      @templates = @templates.page( params[:templates_page]
        ).per( current_profile.per_page
        )
    end
    render params[:view] || '_index'
  end

  def new
    @new_email_template = WcoEmail::EmailTemplate.new
    authorize! :new, WcoEmail::EmailTemplate
  end

  def show
    @tmpl   = WcoEmail::EmailTemplate.where({ id: params[:id] }).first
    @tmpl ||= WcoEmail::EmailTemplate.find_by({ slug: params[:id] })
    authorize! :show, @tmpl

    @ctx    = @email_context = WcoEmail::Context.new
  end

  def show_iframe
    @tmpl   = WcoEmail::EmailTemplate.where({ id: params[:id] }).first
    @tmpl ||= WcoEmail::EmailTemplate.find_by({ slug: params[:id] })
    authorize! :show, @tmpl

    @lead        = Wco::Lead.find_by({ email: 'poxlovi@gmail.com' })
    @ctx         = WcoEmail::Context.new({ email_template: @tmpl, lead: @lead, body: "Lorem Ipsum..." })
    @tmpl_config = OpenStruct.new JSON.parse( @ctx.tmpl[:config_json] )

    @utm_tracking_str = {
      'cid'          => @ctx.lead_id,
      'utm_campaign' => @ctx.tmpl.slug,
      'utm_medium'   => 'email',
      'utm_source'   => @ctx.tmpl.slug,
    }.map { |k, v| "#{k}=#{v}" }.join("&")

    @unsubscribe_url = WcoEmail::Engine.routes.url_helpers.unsubscribes_url({
      template_id: @ctx.tmpl.id,
      lead_id:     @lead.id,
      token:       @lead.unsubscribe_token,
      host:        Rails.application.routes.default_url_options[:host],
    })

    render layout: false
  end

  def update
    @template = WcoEmail::EmailTemplate.where({ id: params[:id] }).first
    authorize! :update, @template
    flag = @template.update_attributes( params[:template].permit! )
    if flag
      flash[:notice] = 'Success.'
    else
      flash[:alert] = "No luck. #{@template.errors.full_messages.join(', ')}"
    end
    redirect_to action: :edit
  end

  ##
  ## private
  ##
  private

end
