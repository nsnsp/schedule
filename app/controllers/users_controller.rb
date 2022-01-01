class UsersController < ApplicationController
  before_action :build_user, only: :create
  load_and_authorize_resource

  # authorize via auth token for commitments.ics
  skip_authorize_resource only: :commitments_ics

  # GET /users
  # GET /users.json
  def index
    @users = @users.order(:suspended, :last_name)
    @users = @users.active unless can? :unsuspend, User
    @season = Season.new
    @commitment_classes =
      Commitment.distinct.pluck(:type).map { |type| type.constantize }
    @commitment_classes.sort! do |a, b|
      [[Commitments::DISPLAY_ORDER.index(a) -
        Commitments::DISPLAY_ORDER.index(b),
        1].min,
       -1].max
    end
    @commitment_counts =
      Commitment.where(date: @season.date_range).group(:user_id, :type).count

    # special case: roll half days into the full day count (kind of ugly)
    klass = @commitment_classes.delete(Commitments::PatrolPM)
    if klass
      half_day_counts = @commitment_counts.select { |key| key[1] == klass.name }
      half_day_counts.each do |half_days_key, half_days_count|
        full_days_key = [half_days_key[0], Commitments::Patrol.name]
        full_days_count = @commitment_counts.fetch(full_days_key, 0) +
          half_days_count * klass.day_multiplier
        @commitment_counts[full_days_key] = full_days_count
        @commitment_counts.delete(half_days_key)
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        flashify_errors(@user, now: true)
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if user_params.roles
        # user_params.roles is a ActionController::Parameters
        user_params.roles = user_params.roles.select{ |key, val| val == "1" }.keys
      end
      puts user_params
      if @user.update(user_params)
        format.html do
          message = @user == current_user ?
            'Your information has been updated.' :
            "#{@user.name}'s information has been updated."
          redirect_to @user, notice: message
        end
        format.json { render :show, status: :ok, location: @user }
      else
        flashify_errors(@user, now: true)
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    respond_to do |format|
      if @user.destroy
        format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      else
        flashify_errors(@user, now: true)
        format.html { render :show }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /commitments
  # GET /commitments.json
  def commitments
    @commitments = Commitment.where(user: @user).order(:date)

    respond_to do |format|
      format.html { redirect_to :root, alert: 'Not implemented yet' }
      format.json { render json: @commitments }
    end
  end

  # GET /commitments.ics
  def commitments_ics
    verify_auth_token(@user)

    @commitments = Commitment.where(user: @user).order(:date)

    respond_to do |format|
      format.ics { render plain: ics }
      format.html { render plain: ics }
    end
  end

  # PUT /users/1/suspend
  # PUT /users/1/suspend.json
  def suspend
    respond_to do |format|
      @user.suspended = true

      if @user.save
        format.html do
          flash[:warning] = "#{@user.name} has been suspended."
          redirect_to @user
        end
        format.json { render :show, status: :ok, location: @user }
      else
        flashify_errors(@user, now: true)
        format.html { render :show }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1/unsuspend
  # PUT /users/1/unsuspend.json
  def unsuspend
    respond_to do |format|
      @user.suspended = false

      if @user.save
        format.html { redirect_to @user, notice: "#{@user.name} has been unsuspended." }
        format.json { render :show, status: :ok, location: @user }
      else
        flashify_errors(@user, now: true)
        format.html { render :show }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.transform_values do |value|
      # remove deselected roles (i.e. those with a value of "0")
      value['roles'].try(:reject!) { |k, v| v.to_i.zero? } if value.is_a?(Hash)
      value
    end

    permitted = :email, :first_name, :last_name, :phone
    permitted << { roles: User.valid_roles } if can? :manage, User
    permitted << :daily_schedule_notification if
      can? :manage_daily_schedule_notification, User.find_by_id(params[:id])
    permitted << :early_schedule_notification if
      can? :early_schedule_notification, User.find_by_id(params[:id])

    params.require(:user).permit(permitted)
  end

  def build_user
    @user = User.new(user_params)
  end

  def ics
    cal = Icalendar::Calendar.new

    cal.prodid = '-//National Ski Patrol//Northstar California//EN'
    cal.x_wr_calname = "NSNSP (#{@user.name})"
    cal.x_wr_timezone = 'America/Los_Angeles'
    cal.x_wr_caldesc = "#{@user.name}'s committed days with Northstar NSP."

    cal.timezone do |t|
      t.tzid = 'America/Los_Angeles'

      t.daylight do |d|
        d.tzoffsetfrom = '-0800'
        d.tzoffsetto   = '-0700'
        d.tzname       = 'PDT'
        d.dtstart      = '19700308T020000'
        d.rrule        = 'FREQ=YEARLY;BYMONTH=3;BYDAY=2SU'
      end

      t.standard do |s|
        s.tzoffsetfrom = '-0700'
        s.tzoffsetto   = '-0800'
        s.tzname       = 'PST'
        s.dtstart      = '19701101T020000'
        s.rrule        = 'FREQ=YEARLY;BYMONTH=11;BYDAY=1SU'
      end
    end

    @commitments.each do |c|
      cal.event do |e|
        e.uid = c.uuid
        e.dtstart = Icalendar::Values::Date.new(c.date)
        e.summary = "NSNSP #{c.display_text}"
        e.description = "#{c.display_text} with Northstar NSP (#{c.user})."
        e.created =
          Icalendar::Values::DateTime.new(c.created_at.utc, 'tzid' => 'UTC')
        e.last_modified =
          Icalendar::Values::DateTime.new(c.updated_at.utc, 'tzid' => 'UTC')
      end
    end

    cal.publish
    cal.to_ical
  end

end
