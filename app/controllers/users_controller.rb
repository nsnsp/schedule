class UsersController < ApplicationController
  load_and_authorize_resource

  # GET /users
  # GET /users.json
  def index
    @users = @users.order(:suspended, :last_name)
    @users = @users.active unless can? :unsuspend, User
    @season = Season.new
    @commitment_classes =
      Commitment.select(:type).uniq.pluck(:type).map { |type| type.constantize }
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
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        flashify_errors(@user)
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
        flashify_errors(@user)
        format.html { render :show }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1/suspend
  # PUT /users/1/suspend.json
  def suspend
    respond_to do |format|
      @user.suspended = true

      if @user.save
        format.html { redirect_to @user, notice: "#{@user.name} has been suspended." }
        format.json { render :show, status: :ok, location: @user }
      else
        flashify_errors(@user)
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
        flashify_errors(@user)
        format.html { render :show }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user]
    end
end
