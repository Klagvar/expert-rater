require 'rails_helper'

RSpec.describe BestImagesController, type: :controller do
  describe "GET #index" do
    let(:theme) { Theme.create(name: "Nature") }
    let!(:image) { Image.create(name: "Test Image", file: "test.jpg", theme: theme) }

    it "returns a successful response and assigns themes" do
      get :index, params: { locale: 'ru' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
      expect(assigns(:themes)).to include(theme)
    end
  end
end