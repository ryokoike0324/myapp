class Clients::NotificationsController < ApplicationController
  before_action :authenticate_client!
  before_action :mark_notifications_as_read

  def index
    @notifications = current_client.received_notifications.order(created_at: :desc).page(params[:page]).per(10)
  end

  private

  def mark_notifications_as_read
    Notification.where(recipient: current_client, unread: true).update_all(unread: false)
  end
end
