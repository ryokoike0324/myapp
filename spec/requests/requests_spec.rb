require 'rails_helper'

RSpec.describe "Requests", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/requests/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/requests/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/requests/show"
      expect(response).to have_http_status(:success)
    end
  end

end
