class Clients::EngagementsController < ApplicationController
  before_action :authenticate_client!

  def create
    applicant = Contractor.find(params[:contractor_id])

    # Engagement レコードを作成して、契約を成立させる
    engagement = Engagement.create(client: current_client, contractor: applicant)

    if engagement.persisted?
      # 成功した場合の処理（フラッシュメッセージの設定、リダイレクトなど）
      redirect_to client_applicant_path(client_id: current_client.id, id: applicant.id), notice: '仕事を依頼しました。'
    else
      # エラー処理
      redirect_back fallback_location: clients_requests_path, alert: '依頼に失敗しました。'
    end
  end
end
