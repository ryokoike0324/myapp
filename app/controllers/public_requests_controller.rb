class PublicRequestsController < ApplicationController
  before_action :set_back_url, only: [:show]
  before_action :set_q, only: [:index]

  # 全てのお仕事一覧
  def index
    # binding.pry_remote
    # 検索結果を取得。distinct: trueにより重複した結果を除外する
    requests = @q.result.unengaged
    # result：ActiveRecord_Relationのオブジェクトに変換するメソッド
    @requests = requests.page(params[:page]).per(10)
    @requests_count = requests.count

    # 複数の検索条件を扱うためparamsの中に入った条件をviewに渡す
    @query_params = ransack_params
  end


  def show
    @request = Request.find(params[:id])
    @owner = @request.client
  end

  private

  # ransack(検索機能)のためストロングパラーメーター
  def ransack_params
    # `params[:q]` の中で許可されるパラメータを明確に定義します。
    # Ransackで使用するフィールド名に合わせて、許可するキーを指定する必要があります。
    params.require(:q).permit(:client_industry_eq, :title_or_description_cont, :s)
  # params[:q] が存在しない場合はそれぞれのカラムの値をnilにして返す
  rescue ActionController::ParameterMissing
    { client_industry_eq: nil, title_or_description_cont: nil, s: nil }
  end

  # ransack(gem)によって検索結果を取得
  def set_q
    params = Client.enum_ransack_params(ransack_params)
    # 許可されたパラメータを基に検索（ransack版のwhere）
    @q = Request.ransack(params)
  end

  # 遷移元の各一覧ページへ確実に戻るため(link_to :back だと意図しない挙動が発生)
  def set_back_url
    allowed_paths = [public_requests_path, clients_requests_path, contractors_request_applications_path, contractors_favorites_path]
    @back_url = params[:back_url] if allowed_paths.include?(params[:back_url])
  end
end
