class InvitesController < ApplicationController
  before_action :set_invite, only: [:show, :edit, :update, :destroy]
  
  def index
    @invites = current_user.invites
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @invites }
    end
  end

  def show
    @invite = Invite.find(params[:id])
    
  end

  def update
    @invite.update(invite_params)
    invitees = @invite.event.invites.map { |invite| {id: invite.user_id, lat: invite.latitude, lng: invite.longitude, name: invite.user.name}}
    respond_to do |format|
      format.json { render json: invitees }
    end
  end

  def destroy
  end

  private
  
  def set_invite
    @invite = Invite.find(params[:id])
  end

  def invite_params
    params.require(:invite).permit(:user_id, :event_id, :rsvp, :location)
  end
end
