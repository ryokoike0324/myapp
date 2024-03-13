class RequestsController < ApplicationController
  before_action :authenticate_client!

  def new
    @request = Request.new
  end

  def create
    @request = current_client.build_request(request_params)
    if @request.save
      redirect_to edit_client_profile_path
    else
      flash.now[:alert] = @request.errors.full_messages.join(', ')
      @request = Request.new
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def show
  end

  private

    def request_params
      params.require(:request).permit(:title, :description, :delivery_date, :deadline)
    end
end
