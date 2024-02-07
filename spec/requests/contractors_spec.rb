require 'rails_helper'

RSpec.describe "Contractors", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/contractors/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/contractors/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/contractors/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/contractors/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy_form" do
    it "returns http success" do
      get "/contractors/destroy_form"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/contractors/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
