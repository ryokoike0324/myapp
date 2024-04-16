class Contractors::FavoritesController < ApplicationController
  before_action :authenticate_contractor!
  before_action :set_request, except: [:index]

  def index
    @requests = current_contractor.favorite_requests.unengaged.page(params[:page]).per(10)
  end

  def create
    # create!はバリデーションに失敗した場合例外を発生させる
    current_contractor.favorites.create!(request_id: @request.id)
    render turbo_stream: turbo_stream.replace(
      # turbo_frame_tagのidをreplace（入れ替え）対象として指定
      'favorite_button',
      # 入れ替えるパーシャルを指定
      partial: 'public_requests/favorite_button',
      locals: { request: @request, favorite: true }
    )
  end

  def destroy
    favorite = current_contractor.favorites.find_by!(request_id: @request.id)
    favorite.destroy!

    render turbo_stream: turbo_stream.replace(
      # turbo_frame_tagのidをreplace（入れ替え）対象として指定
      'favorite_button',
      # 入れ替えるパーシャルを指定
      partial: 'public_requests/favorite_button',
      locals: { request: @request, favorite: false }
    )
  end

  private
  def set_request
    @request = Request.find(params[:id])
  end
end
