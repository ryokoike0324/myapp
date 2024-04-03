class PublicRequestsController < ApplicationController

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
  end

  private

  # 並び替えのデフォルトを新しい順に設定している
  def sort_param
    params[:sort].presence || 'latest'
  end
end
