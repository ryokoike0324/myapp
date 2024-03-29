class Clients::RequestsController < ApplicationController
  before_action :authenticate_client!, except: %i[index show]
  before_action :matching_login_client, only: %i[edit update]
  # application_controllerに記載
  before_action :redirect_if_request_exists, only: %i[new create]
  before_action :redirect_if_no_request, only: %i[edit update]

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
                else
                  Request.all
                end
    @requests = @requests.page(params[:page]).per(10)
  end

  def show
    @request = Request.find(params[:client_id])
  end

  def new
    @request = Request.new
  end

  def edit
    @request = current_client.request
  end

  def create
    @request = current_client.build_request(request_params)
    if @request.save
      flash.now[:notice] = t('.notice')
      redirect_to edit_client_profile_path(current_client)
    else
      @request = Request.new
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @request = current_client.request
    if @request.update(request_params)
      flash[:notice] = t('.notice')
      redirect_to root_path
    else
      # binding.pry_remote
      render 'edit', status: :unprocessable_entity
    end
  end



  private
  # ストロングパラメーター
  def request_params
    params.require(:request).permit(:title, :description, :delivery_date, :deadline)
  end

  def sort_param
    params[:sort].presence || 'latest'
  end

  # すでにお仕事を登録しているユーザーはeditテンプレートにリダイレクトする
  def redirect_if_request_exists
    redirect_to edit_client_request_path(current_client.request) if current_client.request.present?
  end

  # まだお仕事登録していないユーザーはnewテンプレートにリダイレクトする
  def redirect_if_no_request
    redirect_to new_client_request_path(current_client) if current_client.request.nil?
  end
end
