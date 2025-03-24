require 'rails_helper'

RSpec.describe Api::ApiController, type: :controller do
  let(:user) { User.create(name: "Test", email: "test@example.com", password: "password123") }
  let(:theme) { Theme.create(name: "Nature") }
  let(:image) { Image.create(name: "Test Image", file: "test.jpg", theme: theme) }

  before do
    allow(controller).to receive(:signed_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #next_image" do
    before { Image.create(name: "Test", file: "test.jpg", theme: theme) }

    it "returns the next image in JSON format" do
      get :next_image, params: { theme_id: theme.id, index: 0, length: 1 }, format: :json
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("success")
      expect(json_response["new_image_index"]).to eq(0)
    end
  end

  describe "GET #prev_image" do
    before { Image.create(name: "Test", file: "test.jpg", theme: theme) }

    it "returns the previous image in JSON format" do
      get :prev_image, params: { theme_id: theme.id, index: 1, length: 1 }, format: :json
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("success")
      expect(json_response["new_image_index"]).to eq(0)
    end
  end

  describe "POST #rate_image" do
    context "when signed in" do
      it "creates a new rating and returns success" do
        post :rate_image, params: { image_id: image.id, score: 85 }, format: :json
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("success")
        expect(json_response["user_score"]).to eq(85)
        expect(json_response["ave_value"]).to eq(85.0)
      end

      it "updates an existing rating and returns success" do
        Value.create(user: user, image: image, value: 50)
        post :rate_image, params: { image_id: image.id, score: 75 }, format: :json
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response["user_score"]).to eq(75)
      end

      it "returns error if rating fails" do
        allow_any_instance_of(Value).to receive(:save).and_return(false)
        allow_any_instance_of(Value).to receive(:errors).and_return(double(full_messages: ["Invalid"]))
        post :rate_image, params: { image_id: image.id, score: 85 }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when not signed in" do
      it "returns unauthorized" do
        allow(controller).to receive(:signed_in?).and_return(false)
        post :rate_image, params: { image_id: image.id, score: 85 }, format: :json
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["status"]).to eq("unauthorized")
      end
    end
  end
end