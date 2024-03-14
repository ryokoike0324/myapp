require 'rails_helper'

RSpec.describe '受注者' do

  describe 'ログイン' do
    let!(:contractor){ create(:contractor) }

    context '正しい値を入力したとき' do
      it 'ログインに成功すること' do
        visit root_path
        click_link_or_button 'ログイン'
        click_link_or_button '受注者ログイン'
        fill_in 'メールアドレス', with: contractor.email
        fill_in 'パスワード', with: contractor.password
        click_link_or_button '受注者ログイン'
        expect(page).to have_content 'ログインしました。'
        expect(page).to have_link 'ログアウト'
        expect(current_path).to eq root_path
      end
    end

    context '不正な値を入力したとき' do
      it 'ログインに失敗すること' do
        visit root_path
        click_link_or_button 'ログイン'
        click_link_or_button '受注者ログイン'
        fill_in 'メールアドレス', with: 'hogefoobar@123_456'
        fill_in 'パスワード', with: 1234
        click_link_or_button '受注者ログイン'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
        expect(current_path).to eq new_contractor_session_path
        expect(page).to have_link 'ログイン'
      end
    end

    describe 'ゲストユーザーのログイン' do

      it '簡単ログインに成功すること' do
        visit root_path
        click_link_or_button '簡単ログイン'
        click_link_or_button '事業者さんはこちらから'
        expect(page).to have_content 'ログインしました。'
        expect(page).to have_link 'ログアウト'
        expect(current_path).to eq root_path
      end
    end
  end
end
