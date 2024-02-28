class Contractors::ProfilesController < ApplicationController
  before_action :authenticate_contractor!
  before_action :set_contractor, only: %i[edit update]

  def show
  end

  def edit
  end

  def update
    @contractor = current_contractor
    if @contractor.update(profile_params)
      flash[:success] = t('.success')
      redirect_to contractor_profile_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_contractor
    @contractor = Contractor.find(current_contractor.id)
  end

  def profile_params
    params.require(:contractor).permit(:name,
                                       :image,
                                       :public_relations,
                                       :portfolio,
                                       :study_period)
  end
end
