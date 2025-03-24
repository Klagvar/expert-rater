class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :require_admin, only: %i[index show edit update destroy]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    @user.admin = params[:user][:admin] == "true" if current_user&.admin?
    respond_to do |format|
      if @user.save
        sign_in @user  # Автоматический вход после успешной регистрации
        format.html { redirect_to @user, notice: "Пользователь успешно создан." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if current_user&.admin?
        # Принимаем "true", "1", или "on" как истинное значение для admin
        admin_value = ["true", "1", "on"].include?(params[:user][:admin]&.downcase)
        if @user.update(user_params.merge(admin: admin_value))
          format.html { redirect_to @user, notice: "Пользователь успешно обновлен." }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to root_path, alert: "Доступ запрещён" }
        format.json { head :forbidden }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!
    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "Пользователь успешно удален." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])  # Исправлено с params.expect(:id)
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def require_admin
    redirect_to root_path, alert: 'Доступ запрещён' unless current_user&.admin?
  end
end