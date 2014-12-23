class CommitmentsController < ApplicationController
  before_action :set_commitment, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :authenticate_owner!, only: [:show, :edit, :update, :destroy]

  # GET /commitments
  # GET /commitments.json
  def index
    respond_to do |format|
      format.json { render json: Commitment.all }
      format.html do
        @date = params[:date] ? Date.parse(params[:date]) :
          Time.now.hour < 12 ? Date.today : Date.tomorrow
        @new_commitment = Commitment.new(user: current_user, date: @date)
        @commitments = Commitment.where(date: @date).includes(:user)
        # see if we have anything in here before sorting it into an array
        @my_commitment = @commitments.find_by_user_id(current_user.id)
        @commitments = @commitments.sort do |a, b|
          x = [[Commitments::DISPLAY_ORDER.index(a.class) -
                Commitments::DISPLAY_ORDER.index(b.class),
                1].min,
               -1].max
          x.zero? ? (a.user.last_name > b.user.last_name ? 1 : -1) : x
        end
        @events = Commitment.group([:date, :type]).count.map do |key, count|
          commitment_class = key[1].constantize
          { color: commitment_class.display_color,
            start: key[0].strftime('%Y-%m-%d'),
            title: "#{commitment_class.display_text}: #{count}" }
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

    if unavailable?(@commitment.date)
      respond_to do |format|
        format.html do
          message = 'Sign up failed: the date is too soon or too far away.'
          redirect_to commitments_path(date: @commitment.date), alert: message
        end
        format.json { render json: @commitment.errors, status: :unprocessable_entity }
      end
      return
    end

    respond_to do |format|
      if @commitment.save
        format.html do
          redirect_to commitments_path(date: @commitment.date),
            notice: "You're signed up to " \
              "#{uncapitalize @commitment.display_verb} on " \
              "#{@commitment.date.strftime('%A, %-m/%-d/%Y')}."
        end
        format.json { render :show, status: :created, location: @commitment }
      else
        format.html do
          message = 'Sign up failed: ' \
            "#{@commitment.errors.full_messages.to_sentence.downcase}."
          redirect_to commitments_path(date: @commitment.date), alert: message
        end
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
    date = @commitment.date

    if frozen?(date)
      respond_to do |format|
        format.html do
          flash[:alert] =
            "It's too late to cancel for #{date.strftime('%A, %-m/%-d/%Y')}."
          redirect_to commitments_path(date: date)
        end
        format.json { head :no_content }
      end
    else
      @commitment.destroy
      respond_to do |format|
        format.html do
          flash[:info] =
            "You're off the list for #{date.strftime('%A, %-m/%-d/%Y')}."
          redirect_to commitments_path(date: date)
        end
        format.json { head :no_content }
      end
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

    def authenticate_owner!
      unless @commitment.user_id == current_user.id
        redirect_to :commitments, alert: "That doesn't belong to you."
      end
    end

end
