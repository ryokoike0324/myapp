require 'rails_helper'

RSpec.describe "Contractors::Notifications", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/contractors/notifications/index"
      expect(response).to have_http_status(:success)
    end
  end

end
