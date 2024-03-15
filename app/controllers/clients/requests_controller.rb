class Clients::RequestsController < ApplicationController
  before_action :authenticate_client!
  before_action :matching_login_client, only: %i[edit update]
  # application_controllerに記載
  before_action :redirect_if_request_exists, only: %i[new create]
  before_action :redirect_if_no_request, only: %i[edit update]

  def show
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
      redirect_to edit_client_profile_path(current_client)
    else
      flash.now[:alert] = @request.errors.full_messages.join(', ')
      @request = Request.new
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if current_client.update(request_params)
      # flash[:success] = t('success')
      redirect_to rooot
    else
      render 'edit', status: :unprocessable_entity
    end
  end



  private
  # ストロングパラメーター
  def request_params
    params.require(:request).permit(:title, :description, :delivery_date, :deadline)
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
