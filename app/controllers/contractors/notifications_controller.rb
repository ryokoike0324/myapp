class Contractors::NotificationsController < ApplicationController
  before_action :authenticate_contractor!
  before_action :mark_notifications_as_read

  def index
    @notifications = current_contractor.received_notifications.order(created_at: :desc).page(params[:page]).per(10)
  end

  private

  def mark_notifications_as_read
    Notification.where(recipient: current_contractor, unread: true).update_all(unread: false)
  end
end
