
class WcoEmail::EmailActionTemplatesController < WcoEmail::ApplicationController

  before_action :set_lists

  ## Alphabetized : )

  def destroy
    @act = @email_action = WcoEmail::EmailAction.find( params[:id] )
    authorize! :delete, @act
    @act.update_attributes({ deleted_at: Time.now })
    flash_notice 'Probably success'
    redirect_to action: :index
  end

  def edit
    @act = @email_action = WcoEmail::EmailAction.find( params[:id] )
    # @act.ties.push WcoEmail::EmailActionTie.new( next_email_action_id: nil )
    authorize! :edit, @act
  end

  def index
    @email_actions = WcoEmail::EmailAction.where({ :deleted_at => nil })

    authorize! :index, @new_email_action
  end

  def new
    authorize! :new, @new_email_action
  end

  def show
    @act = @email_action = WcoEmail::EmailAction.find( params[:id] )
    authorize! :show, @act
  end

  def update
    if params[:id]
      @act = @email_action = WcoEmail::EmailAction.find( params[:id] )
    else
      @act = @email_action = WcoEmail::EmailAction.new
    end
    authorize! :upsert, @act

    if params[:email_action][:ties_attributes]
      params[:email_action][:ties_attributes].each do |k, v|
        if !v[:next_email_action_id].present?
          params[:email_action][:ties_attributes].delete( k )
        end
        if v[:to_delete] == "1"
          EActie.find( v[:id] ).delete
          params[:email_action][:ties_attributes].delete( k )
        end
      end
    end

    flag = @act.update_attributes( params[:email_action].permit! )
    if flag
      flash[:notice] = 'Success'
      redirect_to action: 'index'
    else
      flash[:alert] = "No luck: #{@act.errors.full_messages.join(', ')}. #{@act.ties.map { |t| t.errors.full_messages.join(', ') }.join(' | ') }"
      render action: 'edit'
    end

  end

  ##
  ## private
  ##
  private

  def set_lists
    @new_email_action = WcoEmail::EmailAction.new
  end

end
