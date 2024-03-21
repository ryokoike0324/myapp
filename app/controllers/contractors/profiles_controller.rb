class Contractors::ProfilesController < ApplicationController
  before_action :authenticate_contractor!
  before_action :matching_login_contractor, only: %i[edit update]
  # application_controllerに記載

  def show
  end

  def edit
  end

  def update

    if current_contractor.update(profile_params)
      flash[:notice] = t('.success')
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:contractor).permit(:name,
                                       :image,
                                       :public_relations,
                                       :portfolio,
                                       :study_period)
  end
end
