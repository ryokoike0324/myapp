class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # protected

  def after_sign_in_path_for(resource)
    if resource.is_a?(Contractor)
      # 受注者の場合のリダイレクト先を設定
      public_requests_path
    elsif resource.is_a?(Client)
      # 発注者の場合のリダイレクト先を設定
      public_requests_path
    end
  end

  private

  # beforeフィルター
  # 今ログインしているユーザーとアクセスしようとしているページのユーザーは同じか（自分以外の人のページにアクセスしようとしていないか）
  # def matching_login_client
  #   @client = Client.find(params[:client_id])
  #   redirect_to(root_url, status: :see_other) unless @client && @client == current_client
  # end

  # def matching_login_contractor
  #   @contractor = Contractor.find(params[:contractor_id])
  #   redirect_to(root_url, status: :see_other) unless @contractor && @contractor == current_contractor
  # end


  # URLに直接IDを入力して使われていないIDのページを閲覧しようとした場合エラー画面を見せない
  def record_not_found
    redirect_to public_requests_path, alert: t('application.not_found')
  end
end
