
class WcoEmail::EmailActionTemplatesController < WcoEmail::ApplicationController

  before_action :set_lists

  ## Alphabetized : )

  def destroy
    @tmpl = WcoEmail::EmailActionTemplate.find( params[:id] )
    authorize! :delete, @tmpl
    @tmpl.delete
    flash_notice 'Probably success'
    redirect_to action: :index
  end

  def edit
    @tmpl = WcoEmail::EmailActionTemplate.find( params[:id] )
    @tmpl.ties.push WcoEmail::EmailActionTemplateTie.new( next_tmpl_id: nil )
    authorize! :edit, @tmpl
  end

  def index
    @tmpls = WcoEmail::EmailActionTemplate.all

    authorize! :index, @new_tmpl
  end

  def new
    authorize! :new, @new_tmpl
  end

  def show
    @tmpl = WcoEmail::EmailActionTemplate.find( params[:id] )
    authorize! :show, @tmpl
  end

  def update # or create
    puts! params, 'params'

    if params[:id]
      @tmpl = WcoEmail::EmailActionTemplate.find( params[:id] )
    else
      @tmpl = WcoEmail::EmailActionTemplate.new
    end
    authorize! :upsert, @tmpl

    if params[:tmpl][:ties_attributes]
      params[:tmpl][:ties_attributes].each do |k, v|
        if !v[:next_tmpl_id].present?
          params[:tmpl][:ties_attributes].delete( k )
        end
        if v[:to_delete] == "1"
          WcoEmail::EmailActionTemplateTie.find( v[:id] ).delete
          params[:tmpl][:ties_attributes].delete( k )
        end
      end
    end

    flag = @tmpl.update_attributes( params[:tmpl].permit! )
    if flag
      flash[:notice] = 'Success'
      redirect_to action: 'index'
    else
      flash[:alert] = "No luck: #{@tmpl.errors.full_messages.join(', ')}. #{@tmpl.ties.map { |t| t.errors.full_messages.join(', ') }.join(' | ') }"
      render action: 'edit'
    end

  end

  ##
  ## private
  ##
  private

  def set_lists
    @email_action_templates_list = WcoEmail::EmailActionTemplate.list
    @email_templates_list = WcoEmail::EmailTemplate.list
    @new_tmpl = WcoEmail::EmailActionTemplate.new
  end

end
