class InviteController < ApplicationController
  def index
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def invite_params
    params.require(:invite).permit(:user_id, :event_id, :rsvp)
  end
end
