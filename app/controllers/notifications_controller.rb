class NotificationsController < ApplicationController

  before_action :set_notification, except:[:index]

  def index
    respond_to do |format|
      if @notifications = current_user.notificaions
        format.json {render json: @notifications}
      end
    end
  end

  def update
    respond_to do |format|
      if @notification.update(notification_params)
        format.json { render json: @notification }
      else
        format.json { render json: @notification.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

  def set_notification
    @notification = Notification.find(params[:id])
  end

  def notification_params
    params.require(:notification).permit(:sender_id, :accept)
  end

end
