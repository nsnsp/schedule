class IdentitiesController < ApplicationController
  load_and_authorize_resource

  # GET /identities
  # GET /identities.json
  def index
    @identities = @identities.includes(:user).sort_by do
      |identity| identity.user.try(:last_name) || ''
    end
  end

  # GET /identities/1
  # GET /identities/1.json
  def show
    @suggested_users = User.where(['email = :email',
                                   'first_name = :first_name',
                                   'last_name = :last_name'].join(' OR '), {
                                    email: @identity.email,
                                    first_name: @identity.first_name,
                                    last_name: @identity.last_name,
                                  })
  end

  # PATCH/PUT /identities/1
  # PATCH/PUT /identities/1.json
  def update
    respond_to do |format|
      if @identity.update(identity_params)
        format.html { redirect_to @identity, notice: 'Identity was successfully updated.' }
        format.json { render :show, status: :ok, location: @identity }
      else
        flashify_errors(@identity)
        format.html { render :show }
        format.json { render json: @identity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /identities/1
  # DELETE /identities/1.json
  def destroy
    respond_to do |format|
      if @identity.destroy
        format.html { redirect_to identities_url, notice: 'Identity was successfully destroyed.' }
        format.json { head :no_content }
      else
        flashify_errors(@identity)
        format.html { render :show }
        format.json { render json: @identity.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def identity_params
    params.require(:identity).permit(:user_id)
  end

end
