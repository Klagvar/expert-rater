class ValuesController < ApplicationController
  before_action :set_value, only: %i[ show edit update destroy ]

  # GET /values or /values.json
  def index
    @values = Value.all
  end

  # GET /values/1 or /values/1.json
  def show
  end

  # GET /values/new
  def new
    @value = Value.new
  end

  # GET /values/1/edit
  def edit
  end

  # POST /values or /values.json
  def create
    @value = Value.new(value_params)

    respond_to do |format|
      if @value.save
        format.html { redirect_to @value, notice: "Value was successfully created." }
        format.json { render :show, status: :created, location: @value }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /values/1 or /values/1.json
  def update
    respond_to do |format|
      if @value.update(value_params)
        format.html { redirect_to @value, notice: "Value was successfully updated." }
        format.json { render :show, status: :ok, location: @value }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /values/1 or /values/1.json
  def destroy
    @value.destroy!

    respond_to do |format|
      format.html { redirect_to values_path, status: :see_other, notice: "Value was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_value
      @value = Value.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def value_params
      params.expect(value: [ :user_id, :image_id, :value ])
    end
end
