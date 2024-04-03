class Contractors::RequestApplicationsController < ApplicationController
  before_action :authenticate_contractor!

  # GET	/contractors/request_applications
  # 現在ログインしているcontractorの申し込みしたお仕事の一覧を取得
  def index
    @requests = current_contractor.applied_requests.page(params[:page]).per(10)
    # applications = current_contractor.request_applications.includes(:request)
    # @requests = applications.map(&:request).page(params[:page]).per(10)
  end

  # POST /contractors/request_applications
  def create
    application = RequestApplication.new(contractor: current_contractor, request_id: params[:request_id])
    if application.save
      # 成功した場合の処理
      redirect_back fallback_location: clients_requests_path
    else
      # エラー処理
      flash[:alert] = t('.alert')
      # 現在のページを再表示
      redirect_back fallback_location: clients_requests_path, status: :see_other
    end
  end

  # DELETE /contractors/request_applications/:id
  def destroy
    application = RequestApplication.find_by(contractor: current_contractor, request_id: params[:request_id])
    application&.destroy
    # 成功した場合の処理
    redirect_back fallback_location: clients_requests_path
  end

end
