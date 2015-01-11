class CommitmentsController < ApplicationController
  before_filter :build_resource, only: :create
  load_and_authorize_resource

  # authorize via temporize token for notify_today.json
  skip_authorize_resource only: :notify_today
  protect_from_forgery with: :null_session, only: :notify_today

  # GET /commitments
  # GET /commitments.json
  def index
    respond_to do |format|
      format.json { render json: Commitment.all }
      format.html do
        @date = params[:date] ? Date.parse(params[:date]) :
          Time.now.hour < 12 ? Date.today : Date.tomorrow
        @new_commitment = Commitment.new(user: current_user, date: @date)
        @date_commitments = @commitments.includes(:user).
          where(date: @date, users: { suspended: false })
        @my_commitment = @date_commitments.find_by_user_id(current_user.id)
        @events = Commitment.joins(:user).where(users: { suspended: false }).
          group([:date, :type]).count.map do |key, count|
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

  # POST /commitments
  # POST /commitments.json
  def create
    respond_to do |format|
      if @commitment.save
        format.html do
          name = @commitment.user == current_user ? "You're" :
            "#{@commitment.user.name} is"
          notice = "#{name} signed up to " \
            "#{uncapitalize @commitment.display_verb} on " \
            "#{@commitment.date.strftime('%A, %-m/%-d/%y')}."
          redirect_to commitments_path(date: @commitment.date), notice: notice
        end
        format.json { render :show, status: :created, location: @commitment }
      else
        format.html do
          flashify_errors(@commitment)
          redirect_to commitments_path(date: @commitment.date)
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

    respond_to do |format|
      if @commitment.destroy
        format.html do
          name = user == current_user ? "You're" : "#{user.name} is"
          flash[:info] =
            "#{name} off the list for #{date.strftime('%A, %-m/%-d/%y')}."
          redirect_to commitments_path(date: date)
        end
        format.json { head :no_content }
      else
        flashify_errors(@commitment)
        format.html { redirect_to commitments_path(date: date) }
        format.json { render json: @commitment.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /commitments/notify_today.json
  def notify_today
    verify_temporize_token

    CommitmentMailer.notify_today.deliver_later

    respond_to do |format|
      format.json do
        render json: @commitments
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
