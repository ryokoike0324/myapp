class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # protected

  def after_sign_in_path_for(resource)
    if resource.is_a?(Contractor)
      # 受注者の場合のリダイレクト先を設定
      clients_requests_path
    elsif resource.is_a?(Client)
      # 発注者の場合のリダイレクト先を設定
      root_path
    end
  end

  private

  # beforeフィルター

  # URLに直接IDを入力して使われていないIDのページを閲覧しようとした場合エラー画面を見せない
  def record_not_found
    redirect_to root_url, alert: t('application.not_found')
  end
end
