require 'rails_helper'

RSpec.describe WorkController, type: :controller do
  let(:user) { User.create(name: "Test", email: "test@example.com", password: "password123") }
  let(:theme) { Theme.create(name: "Nature") }
  let(:image) { Image.create(name: "Test Image", file: "test.jpg", theme: theme) }

  describe "GET #index" do
    it "returns a successful response and sets default data" do
      get :index, params: { locale: 'ru' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
      expect(assigns(:selected_theme)).to eq("Выберите тему")
      expect(assigns(:image_data)[:file]).to eq("placeholder.jpg")
    end
  end

  describe "GET #choose_theme" do
    before { Theme.create(name: "Nature") }

    it "responds with JS format" do
      get :choose_theme, params: { locale: 'ru' }, format: :js
      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq("text/javascript")
    end

    it "redirects to root for HTML format" do
      get :choose_theme, params: { locale: 'ru' }
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST #display_theme" do
    context "with a valid theme" do
      before do
        controller.sign_in(user)
        theme = Theme.create(name: "Nature")  # Создаём тему
        Image.create(name: "Test Image", file: "test.jpg", theme: theme)  # Связываем изображение с темой
      end

      it "displays the theme's first image and responds with JS" do
        post :display_theme, params: { locale: 'ru', theme: "Nature" }, format: :js
        expect(response).to have_http_status(:success)
        expect(assigns(:image_data)[:theme]).to eq("Nature"), "Theme should be 'Nature', got #{assigns(:image_data)[:theme]}"
        expect(assigns(:image_data)[:file]).to eq("test.jpg"), "File should be 'test.jpg', got #{assigns(:image_data)[:file]}"
      end
    end

    context "with a blank theme" do
      it "returns default data" do
        post :display_theme, params: { locale: 'ru', theme: "" }, format: :js
        expect(assigns(:image_data)[:file]).to eq("placeholder.jpg")
      end
    end

    context "when signed in with a rating" do
      before do
        controller.sign_in(user)
        Value.create(user: user, image: image, value: 75)
      end

      it "includes user score and ave_value" do
        post :display_theme, params: { locale: 'ru', theme: "Nature" }, format: :js
        expect(assigns(:image_data)[:user_score]).to eq(75)
        expect(assigns(:image_data)[:ave_value]).to eq(75.0)
      end
    end
  end
end