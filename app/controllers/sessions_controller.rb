class SessionsController < ApplicationController
  def new
  end

  def signup
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to root_url, notice: 'Вход выполнен успешно!'
    else
      flash.now[:alert] = 'Неверный email или пароль'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url, notice: 'Вы вышли из системы'
  end

  def profile
    @user = current_user  # Получаем текущего пользователя из SessionsHelper
    redirect_to signin_path, alert: 'Пожалуйста, войдите в систему' unless signed_in?
  end

  def create_user
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_to root_url, notice: 'Регистрация прошла успешно!'
    else
      render 'signup', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end