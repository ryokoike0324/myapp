class Clients::RequestsController < ApplicationController
  before_action :authenticate_client!

  def index
    @requests = current_client.requests.unengaged.page(params[:page]).per(10)
  end

  # 受注者側に見せるためcurrent_clientは使えない
  # idから対象のデータを探す

  def new
    @request = Request.new
  end

  def edit
    @request = Request.find(params[:id])
  end

  def create
    @request = current_client.requests.build(request_params)
    if @request.save
      flash[:notice] = t('.notice')
      redirect_to public_requests_path
    else
      # @request = Request.new
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @request = Request.find(params[:id])
    if @request.update(request_params)
      flash[:notice] = t('.notice')
      redirect_to clients_requests_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    request = Request.find(params[:id])
    request.delete
    flash[:notice] = 'お仕事を削除しました。'
    redirect_to clients_requests_path
  end



  private
  # ストロングパラメーター
  def request_params
    params.require(:request).permit(:title, :description, :delivery_date, :deadline)
  end

  # 並び替えのデフォルトを新しい順に設定している
  def sort_param
    params[:sort].presence || 'latest'
  end
end
