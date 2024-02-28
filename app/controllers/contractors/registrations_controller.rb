# frozen_string_literal: true

class Contractors::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create, :profile_create]
  # before_action :configure_account_update_params, only: [:profile_create]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  # super
  #   redirect_to privacy_path
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end



  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [
  #     :name,
  #     :image,
  #     :public_relations,
  #     :portfolio,
  #     :study_period
  #   ])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [
  #                                       :name,
  #                                       :image,
  #                                       :public_relations,
  #                                       :portfolio,
  #                                       :study_period
  #                                     ])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    edit_contractor_profile_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
