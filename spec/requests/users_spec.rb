require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/users/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /users" do
    it "creates a user and redirects to group creation" do
      post "/users", params: {
        user: {
          email: "test2@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }

      expect(response).to redirect_to(new_group_path)
    end
  end
end
