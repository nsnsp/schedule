class CommitmentsController < ApplicationController
  before_filter :build_resource, only: :create
  load_and_authorize_resource

  # GET /commitments
  # GET /commitments.json
  def index
    respond_to do |format|
      format.json { render json: Commitment.all }
      format.html do
        @date = params[:date] ? Date.parse(params[:date]) :
          Time.now.hour < 12 ? Date.today : Date.tomorrow
        @new_commitment = Commitment.new(user: current_user, date: @date)
        @date_commitments = @commitments.where(date: @date).includes(:user)
        # see if we have anything in here before sorting it into an array
        @my_commitment = @date_commitments.find_by_user_id(current_user.id)
        @date_commitments = @date_commitments.sort do |a, b|
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
        @season = Season.new
        @my_commitments = Commitment.
          where(date: @season.date_range, user: current_user).order(:date)
      end
    end
  end

  # GET /commitments/1
  # GET /commitments/1.json
  def show
  end

  # POST /commitments
  # POST /commitments.json
  def create
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
          name = @commitment.user == current_user ? "You're" :
            "#{@commitment.user.name} is"
          redirect_to commitments_path(date: @commitment.date),
            notice: "#{name} signed up to " \
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

  # DELETE /commitments/1
  # DELETE /commitments/1.json
  def destroy
    date = @commitment.date
    user = @commitment.user

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
          name = user == current_user ? "You're" : "#{user.name} is"
          flash[:info] =
            "#{name} off the list for #{date.strftime('%A, %-m/%-d/%Y')}."
          redirect_to commitments_path(date: date)
        end
        format.json { head :no_content }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def build_resource
    resource_params = params.require(:commitment).permit(:user_id, :date, :type)
    @commitment = Commitment.new(resource_params)
  end

end
