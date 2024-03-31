class Clients::EngagementsController < ApplicationController
  before_action :authenticate_client!
  before_action :correct_applicant, only: [:create]

  def create

    # Engagement レコードを作成して、契約を成立させる
    engagement = Engagement.new(client: current_client, contractor: applicant)

    if engagement.save
      # 成功した場合の処理（フラッシュメッセージの設定、リダイレクトなど）
      redirect_to clients_applicant_path(client_id: current_client.id, id: applicant.id), notice: '仕事を依頼しました。'
    else
      # エラー処理
      redirect_back fallback_location: clients_requests_path, alert: '依頼に失敗しました。'
    end
  end

  private

  def correct_applicant
    applicant = Contractor.find(params[:contractor_id])
    redirect_to if current_client.request.applicants.include?(applicant)
  end
end
