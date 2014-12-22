class CommitmentsController < ApplicationController
  before_action :set_commitment, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /commitments
  # GET /commitments.json
  def index
    respond_to do |format|
      format.json { render json: Commitment.all }
      format.html do
        @today_commitments =
          Commitment.where(date: Date.today).includes(:user)
        @tomorrow_commitments =
          Commitment.where(date: Date.tomorrow).includes(:user)

        if params[:date]
          @other_date = Date.parse(params[:date])
          @other_commitments =
            Commitment.where(date: @other_date).includes(:user)
        end
      end
    end
  end

  # GET /commitments/1
  # GET /commitments/1.json
  def show
  end

  # GET /commitments/new
  def new
    @commitment = Commitment.new
  end

  # GET /commitments/1/edit
  def edit
  end

  # POST /commitments
  # POST /commitments.json
  def create
    @commitment = Commitment.new(commitment_params)

    respond_to do |format|
      if @commitment.save
        format.html { redirect_to @commitment, notice: 'Commitment was successfully created.' }
        format.json { render :show, status: :created, location: @commitment }
      else
        format.html { render :new }
        format.json { render json: @commitment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /commitments/1
  # PATCH/PUT /commitments/1.json
  def update
    respond_to do |format|
      if @commitment.update(commitment_params)
        format.html { redirect_to @commitment, notice: 'Commitment was successfully updated.' }
        format.json { render :show, status: :ok, location: @commitment }
      else
        format.html { render :edit }
        format.json { render json: @commitment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commitments/1
  # DELETE /commitments/1.json
  def destroy
    @commitment.destroy
    respond_to do |format|
      format.html { redirect_to commitments_url, notice: 'Commitment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commitment
      @commitment = Commitment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def commitment_params
      params.require(:commitment).permit(:user_id, :date, :type)
    end
end
