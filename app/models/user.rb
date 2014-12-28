class User < ActiveRecord::Base
  include Nameable

  has_paper_trail

  has_many :commitments, inverse_of: :user
  has_many :identities, inverse_of: :user

  validates :first_name, :last_name, presence: true
  validates :email, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  }

  scope :active, -> { where(suspended: false) }
  scope :suspended, -> { where(suspended: true) }

  strip_attributes collapse_spaces: true

  alias_method :to_s, :name
end
