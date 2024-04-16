class Clients::EngagementsController < ApplicationController
  before_action :authenticate_client!
  before_action :correct_request, only: [:create]
  before_action :correct_applicant, only: [:create]

  def index
    # joins(内部結合)は、両方のテーブルにマッチするレコードのみを結果に含めるため、engagement と関連を持っていない request レコードは結果に含まれない
    # このクエリ自体はrequestsテーブルのフィールドに基づくレコードを返す（engagementの情報は含まれない）
    @requests = current_client.requests.joins(:engagement)
                              .order('requests.created_at DESC')
                              .page(params[:page])
                              .per(10)
  end

  def show

  end

  def create

    # Engagement レコードを作成して、契約を成立させる
    engagement = Engagement.new(request_id: params[:request_id], contractor_id: params[:applicant_id])

    if engagement.save
      redirect_to clients_applicant_path(id: @contractor.id, request_id: @request.id), notice: t('.engaged')
    else
      # エラー処理
      redirect_back fallback_location: clients_applicant_path(id: @contractor.id, request_id: @request.id), alert: t('.failure')
    end
  end

  private

  # 発注する仕事は発注者が持つ仕事か
  def correct_request
    @request = Request.find(params[:request_id])
    redirect_back fallback_location: clients_applicants_path, alert: t('.alert_request') unless current_client.requests.include?(@request)
  end

  # 受注する応募者は指定のお仕事に応募してきた応募者か
  def correct_applicant
    # showアクションでも@contractorを渡すから、@applicantとしない（意味的に応募者だとおかしくなるので）
    @contractor = Contractor.find(params[:applicant_id])
    redirect_back fallback_location: clients_applicants_path, alert: t('.alert_applicant') unless @request.applicants.include?(@contractor)
  end
end
