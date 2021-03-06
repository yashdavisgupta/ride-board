module NotificationManager
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_ride
  end

  def show
  end

  def update
    if current_user.update(notify_params)
      notifier = Notifier::Service.new
      notifier.notify(current_user,
        "You are now receiving notifications from RideBoard.app. " +
        "Change you preferences any time at #{notify_url}")

      redirect_to redirect_path,
                  notice: 'Notification preferences were successfully updated.'
    else
      render :show
    end
  end

  private
    def set_ride
      @ride = Ride.find(params[:ride_id])
    end

    def notify_params
      filtered_params = params
        .require(:user)
        .permit(:notify_email, :notify_sms, :phone_number)

      if !filtered_params[:phone_number].nil?
        if filtered_params[:phone_number] == ''
          filtered_params[:phone_number] = nil
        else
          filtered_params[:phone_number].tr!('- ()', '')
        end
      end

      filtered_params
    end
end
