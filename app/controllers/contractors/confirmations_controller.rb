# frozen_string_literal: true

class Contractors::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    # ↓コメントを挿入した以降の行の警告を無視できる
    # rubocop:disable Rails/DynamicFindBy
    @confirmed = resource_class.find_by_confirmation_token(params[:confirmation_token]).confirmed_at
    # rubocop:enable Rails/DynamicFindBy
    super do
      sign_in resource
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  def after_confirmation_path_for(_resource_name, resource)
    # root_path

    if resource.instance_of?(Contractor) && @confirmed.nil?
      # binding.remote_pry
      # 新規登録の場合の遷移先
      edit_contractor_profile_path(resource)
    else
      # アカウント情報更新の場合の遷移先
      root_path
    end
  end
end
