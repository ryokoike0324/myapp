class ApplicationController < ActionController::Base

  protected

  def after_sign_in_path_for(resource)
    if resource.is_a?(Contractor)
      # 受注者の場合のリダイレクト先を設定
      privacy_path
    elsif resource.is_a?(Client)
      # 発注者の場合のリダイレクト先を設定
      terms_path
    end
  end
end
