require 'csv'


class WcoEmail::ContextsController < WcoEmail::ApplicationController

  before_action :set_lists

  def create
    @ctx    = WcoEmail::Context.new params[:context].permit!
    @tmpl   = WcoEmail::EmailTemplate.find @ctx.email_template_id

    @ctx.from_email ||= @tmpl.from_email
    @ctx.subject    ||= @tmpl.subject

    if params[:respond_inline]
      @ctx.reply_to_message_id = params[:respond_inline]
    end

    authorize! :create, @ctx
    if @ctx.save
      flash_notice 'Saved.'
      redirect_to action: 'show', id: @ctx.id
      return
    else
      flash_alert @ctx
      redirect_to request.referrer
    end
  end

  def destroy
    @ctx = WcoEmail::Context.find params[:id]
    authorize! :destroy, @ctx
    flag = @ctx.destroy
    if flag
      flash[:notice] = 'Destroyed the email context'
    else
      flash[:alert] = 'Could not destroy email context'
    end
    redirect_to action: :index
  end

  def edit
    @ctx = WcoEmail::Context.find params[:id]
    authorize! :edit, @ctx
  end

  def iframe_src
    @ctx = @email_context = WcoEmail::Context.find params[:id]
    authorize! :iframe_src, @ctx

    @tmpl        = @email_template = @ctx.email_template
    @tmpl_config = OpenStruct.new JSON.parse( @ctx.tmpl[:config_json] )
    @lead        = @ctx.lead
    @body        = @ctx.body

    render layout: false
  end

  def index
    authorize! :index, WcoEmail::Context
    @ctxs = WcoEmail::Context.all.order_by( sent_at: :desc, send_at: :desc
      ).page( params[:ctxs_page]
      ).per( current_profile.per_page )

    if params[:lead_id]
      @lead = Lead.find params[:lead_id]
      @ctxs = @ctxs.where( lead_id: @lead.id )
    else
      if my_truthy? params[:sent]
        @ctxs = @ctxs.or({ :sent_at.ne => nil }, { :unsubscribed_at.ne => nil })
      else
        @ctxs = @ctxs.where( sent_at: nil, unsubscribed_at: nil )
      end
    end
  end

  def new
    authorize! :new, WcoEmail::Context
    @tmpl = @email_template = WcoEmail::EmailTemplate.where( slug: params[:template_slug] ).first ||
      WcoEmail::EmailTemplate.where( id: params[:template_slug] ).first ||
      WcoEmail::EmailTemplate.new
    attrs = {}
    if @tmpl
      attrs = @tmpl.attributes.slice( :subject, :body, :from_email )
    end
    @ctx = WcoEmail::Context.new({ email_template: @tmpl }.merge(attrs))
  end

  def send_immediate
    @ctx = WcoEmail::Context.find params[:id]
    authorize! :do_send, @ctx
    flash_notice 'Sent immediately.'

    out = WcoEmail::ApplicationMailer.send_context_email( @ctx[:id].to_s )
    Rails.env.production? ? out.deliver_later : out.deliver_now

    redirect_to action: 'index'
  end

  def send_schedule
    @ctx = WcoEmail::Context.find params[:id]
    authorize! :do_send, @ctx

    flash[:notice] = 'Scheduled a single send - v2'
    @ctx.send_at = Time.now
    @ctx.save

    redirect_to action: 'index'
  end

  def show
    @ctx = @email_context = WcoEmail::Context.find( params[:id] )
    authorize! :show, @ctx
  end

  def summary
    authorize! :summary, WcoEmail::Context
    @results = WcoEmail::Context.summary

    respond_to do |format|
      format.html
      format.csv do
        render layout: false
      end
    end
  end

  def update
    @ctx = WcoEmail::Context.find params[:id]
    authorize! :update, @ctx

    if @ctx.update_attributes params[:ctx].permit!
      flash[:notice] = 'Saved.'
      redirect_to action: 'edit', id: @ctx.id
      return
    else
      flash[:alert] = "Could not save: #{@ctx.errors.full_messages.join(', ')}"
      render action: :edit
      return
    end
  end

  ##
  ## Private
  ##
  private

  def set_lists
    super
    @email_layouts_list   = WcoEmail::EmailTemplate::LAYOUTS
    @email_templates_list = [ [nil, nil] ] + WcoEmail::EmailTemplate.all.map { |tmpl| [ tmpl.slug, tmpl.id ] }
    @leads_list = Wco::Lead.list
  end

end

