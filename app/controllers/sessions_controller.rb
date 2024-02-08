class SessionsController < Devise::SessionsController
  def create
    #superにより親クラスの同名メソッドを実行
    #その後のブロックにより追加の処理を実行
    #ログインに成功したユーザーがresourceとして渡される
    super do |resource|
      if resource.is_a?(Client)
        redirect_to root_path
      elsif resource.is_a?(Contractor)
        redirect_to static_pages_about
      end
    end
  end
end