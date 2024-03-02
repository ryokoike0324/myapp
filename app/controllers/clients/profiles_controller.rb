class Clients::ProfilesController < ApplicationController
  before_action :authenticate_client!
  before_action :set_client, only: %i[edit update]

  def show
  end

  def edit
  end

  def update
    @client = current_client
    if @client.update(profile_params)
      flash[:success] = t('.success')
      redirect_to client_profile_path(current_client)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_client
    @client = Client.find(current_client.id)
  end

  def profile_params
    params.require(:client).permit(:name,
                                   :industry,
                                   :our_business)
  end
end
