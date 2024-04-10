require 'rails_helper'

RSpec.describe "Clients::Notifications", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/clients/notifications/index"
      expect(response).to have_http_status(:success)
    end
  end

end
