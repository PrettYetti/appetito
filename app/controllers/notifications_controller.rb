class NotificationsController < ApplicationController

  before_action :set_notification, except:[:index]

  def index
    @notifications = current_user.notifications
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @notifications }
    end
  end

  def update
    # binding.pry
    respond_to do |format|
      if @notification.update(notification_params)
        format.html { redirect_to current_user }
        format.json { render json: @notification }
      else
        format.html { redirect_to current_user }
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

  def set_type

  end

  def notification_params
    type = @notification.type if @notification
    params.require(type.underscore.to_sym).permit(:sender_id, :accept)
  end

end
