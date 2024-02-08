class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    if resource.is_a?(Contractor)
      # 受注者の場合のリダイレクト先を設定
      # contractor_dashboard_path
    elsif resource.is_a?(Client)
      # 発注者の場合のリダイレクト先を設定
      # client_dashboard_path
    else
      super
    end
  end
end
