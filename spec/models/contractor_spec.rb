require 'rails_helper'

RSpec.describe Contractor do
  describe 'ユーザー登録' do
    it "email、passwordとpassword_confirmationが存在すれば登録できること" do
      con_user = build(:contractor)
      expect(con_user).to be_valid  # user.valid? が true になればパスする
    end
  end
end
