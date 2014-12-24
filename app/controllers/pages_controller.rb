class PagesController < ApplicationController
  include HighVoltage::StaticPage

  before_filter :forward_from_root_if_logged_in

  private

  def forward_from_root_if_logged_in
    if params[:id] == 'home' && current_user
      redirect_to after_sign_in_path_for(current_user), status: 302 and return
    end
  end
end
