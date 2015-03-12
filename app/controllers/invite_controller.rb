class InviteController < ApplicationController
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

  def create

  end

  def update

  end

  def destroy
  end

  private

  def invite_params
    params.require(:invite).permit(:user_id, :event_id, :rsvp, :location)
  end
end
