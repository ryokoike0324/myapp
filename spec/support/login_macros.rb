module LoginMacros
  def log_in_as(user)
    user_type = user.instance_of?(Client) ? 'client' : 'contractor'
    user_type_ja = user.instance_of?(Client) ? '発注者' : '受注者'
    visit send(:"new_#{user_type}_session_path")
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_link_or_button "#{user_type_ja}ログイン"
    # ページが表示される前にテストが先に進むのを防ぐため以下のコードを挿入
    expect(page).to have_content 'ログインしました'
  end
end
