class PublicRequestsController < ApplicationController
  before_action :set_back_url, only: [:show]

  # 全てのお仕事一覧
  def index
    @requests = case sort_param
                when 'latest'
                  Request.latest
                when 'old'
                  Request.old
                when 'until_deadline'
                  Request.until_deadline
                when 'until_delivery_date'
                  Request.until_delivery_date
                when 'applicants_order'
                  Request.applicants_order
                when 'likes_order'
                  Request.likes_order
                else
                  Request.all
                end
                @requests = @requests.page(params[:page]).per(10)
  end

  def show
    @request = Request.find(params[:id])
    @owner = @request.client
  end

  private

  # 並び替えのデフォルトを新しい順に設定している
  def sort_param
    params[:sort].presence || 'latest'
  end

  # 遷移元の各一覧ページへ確実に戻るため(link_to :back だと意図しない挙動が発生)
  def set_back_url
    allowed_paths = [public_requests_path, clients_requests_path, contractors_request_applications_path, contractors_favorites_path]
    @back_url = params[:back_url] if allowed_paths.include?(params[:back_url])
  end
end
