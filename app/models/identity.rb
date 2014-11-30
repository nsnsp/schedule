class Identity < ActiveRecord::Base
  belongs_to :user, inverse_of: :identities

  validates :auth0_uid, uniqueness: true
end
