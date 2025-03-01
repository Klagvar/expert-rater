class MainController < ApplicationController
  def index
    @users = User.all
  end

  def help
  end

  def contacts
  end

  def about
  end
end
