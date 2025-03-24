require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { User.create(name: "Test", email: "test@example.com", password: "password123") }

  describe "GET #new" do
    it "returns a successful response" do
      get :new, params: { locale: 'ru' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
    end
  end

  describe "GET #signup" do
    it "returns a successful response and initializes a new user" do
      get :signup, params: { locale: 'ru' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:signup)
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "signs in the user and redirects to root" do
        post :create, params: { locale: 'ru', session: { email: user.email.downcase, password: "password123" } }
        expect(session[:user_id]).to eq(user.id), "Session[:user_id] should be set after sign_in"
        expect(controller).to be_signed_in, "User should be signed in"
        expect(response).to redirect_to(root_url)
        expect(flash[:notice]).to eq("Вход выполнен успешно!")
      end
    end

    context "with invalid credentials" do
      it "renders new with an alert" do
        post :create, params: { locale: 'ru', session: { email: user.email, password: "wrong" } }
        expect(session[:user_id]).to be_nil
        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq("Неверный email или пароль")
      end
    end
  end

  describe "DELETE #destroy" do
    before { controller.sign_in(user) }

    it "signs out the user and redirects to root" do
      delete :destroy, params: { locale: 'ru' }
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_url)
      expect(flash[:notice]).to eq("Вы вышли из системы")
    end
  end

  describe "GET #profile" do
    context "when signed in" do
      before { controller.sign_in(user) }

      it "returns a successful response and assigns current user" do
        get :profile, params: { locale: 'ru' }
        expect(response).to have_http_status(:success)
        expect(assigns(:user)).to eq(user)
      end
    end

    context "when not signed in" do
      it "redirects to signin with an alert" do
        get :profile, params: { locale: 'ru' }
        expect(response).to redirect_to(signin_path)
        expect(flash[:alert]).to eq("Пожалуйста, войдите в систему")
      end
    end
  end

  describe "POST #create_user" do
    context "with valid attributes" do
      it "creates a new user and signs in" do
        expect {
          post :create_user, params: { locale: 'ru', user: { name: "NewUser", email: "new@example.com", password: "password123", password_confirmation: "password123" } }
        }.to change(User, :count).by(1)
        expect(session[:user_id]).to eq(User.last.id), "Session[:user_id] should be set after sign_in"
        expect(controller).to be_signed_in, "User should be signed in"
        expect(response).to redirect_to(root_url)
        expect(flash[:notice]).to eq("Регистрация прошла успешно!")
      end
    end

    context "with invalid attributes" do
      it "renders signup with errors" do
        post :create_user, params: { locale: 'ru', user: { name: "", email: "new@example.com", password: "pass" } }
        expect(response).to render_template(:signup)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end