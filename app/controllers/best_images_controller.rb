class BestImagesController < ApplicationController
  def index
    @themes = Theme.includes(:images).all
  end
end