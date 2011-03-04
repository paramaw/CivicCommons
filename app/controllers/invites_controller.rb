class InvitesController < ApplicationController
  def new
    @source_type = params[:source_type]
    @source_id = params[:source_id]
    if @source_type == 'conversations'
      @conversation = Conversation.find(@source_id)
    end

    respond_to do |format|
      format.html
    end
  end

  def create
    @source_type = params[:source_type]
    @source_id = params[:source_id]

    emails = params[:invites][:emails]
    if emails.size > 6 # x@xx.xx
      @conversation = Conversation.find_by_id(@source_id)
      @conversation = Conversation.first unless @conversation
      result = Invite.send_invites(emails, current_person, @conversation)
    else
      result = nil
    end

    respond_to do |format|
      if result
        notice = "Thank you! You're helping to make Northeast Ohio stronger!"
        format.html { redirect_to({ :controller => @source_type, :action => :show, :id => @source_id }, :notice => notice) }
      else
        flash[:notice] = "There was a problem with the entered emails."
        format.html { render :action => "new" }
      end
    end
  end

end
