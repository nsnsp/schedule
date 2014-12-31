module CommitmentsHelper
  def commitments_webcal_path(user)
    # deliberately use current_user auth_token (and user ID) for security
    commitments_ics_user_path(user, only_path: false, format: :ics,
                              protocol: :webcal,
                              auth_token: current_user.auth_token)
  end
end
