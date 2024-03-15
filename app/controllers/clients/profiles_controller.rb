class Clients::ProfilesController < ApplicationController
  before_action :authenticate_client!
  before_action :matching_login_client, only: %i[edit update]
  # application_controllerに記載

  def show
  end

  def edit
  end

  def update
    if current_client.update(profile_params)
      flash[:success] = t('.success')
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:client).permit(:name,
                                   :industry,
                                   :our_business)
  end
end
