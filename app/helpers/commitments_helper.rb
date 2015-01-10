module CommitmentsHelper
  def commitments_webcal_path(user)
    # deliberately use current_user auth_token (and user ID) for security
    commitments_ics_user_path(user, only_path: false, format: :ics,
                              protocol: :webcal,
                              auth_token: current_user.auth_token)
  end

  # return an array of commitments in proper display order given an enumerable
  # of Commitment objects; suggest including/joining :users in your query
  def in_display_order(commitments)
    commitments.sort do |a, b|
      x = [[Commitments::DISPLAY_ORDER.index(a.class) -
            Commitments::DISPLAY_ORDER.index(b.class),
            1].min,
           -1].max
      x.zero? ? (a.user.last_name > b.user.last_name ? 1 : -1) : x
    end
  end

end
