class Clients::ApplicantsController < ApplicationController
  before_action :authenticate_client!
  before_action :matching_login_client, only: %i[index show]
  # showアクションにset_requestをかけているのは、check_if_applicant_exists内で@requestにアクセスしているため
  before_action :set_request, only: [:index, :show]
  before_action :check_if_applicant_exists, only: [:show]


  def index
    @applicants = @request.applicants
  end

  def show
    @applicant = Contractor.find(params[:id])
  end

  private

  # ログインしている発注者の登録している仕事を取得、なければリダイレクト
  def set_request
    @request = current_client.request
    redirect_to new_client_request_path, alert: t('.no_request_alert') unless @request
  end

  # 指定されたRequestに対してContractorが応募しているかを検証
  # @request（お仕事）に応募したapplicants(応募者の集合)の中に見ようとしている応募者のidがあるか確認している
  def check_if_applicant_exists
    redirect_back(fallback_location: clients_requests_path, alert: t('.not_found_alert')) unless @request.applicants.exists?(id: params[:id])
  end
end
