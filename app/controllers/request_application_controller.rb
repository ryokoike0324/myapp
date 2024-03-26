class RequestApplicationController < ApplicationController
  before_action :authenticate_contractor!

  def index
    # 現在ログインしているcontractorの申し込みしたお仕事の一覧を取得
    @applications = current_contractor.request_applications.includes(:request)
  end

  # app/controllers/requests_controller.rb
  def apply
    application = RequestApplication.new(contractor: current_contractor, request_id: params[:id])
    if application.save
      # 成功した場合の処理
      redirect_to clients_requests_path
    else
      # エラー処理
      flash[:alert] = t('.alert')
      # 現在のページを再表示
      redirect_to clients_requests_path, alert: t('.alert'), status: :see_other
    end
  end

  def cancel_application
    application = RequestApplication.find_by(contractor: current_contractor, request_id: params[:id])
    application&.destroy
    # 成功した場合の処理
    redirect_to clients_requests_path
  end

end
