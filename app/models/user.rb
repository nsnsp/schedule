class User < ActiveRecord::Base
  include Nameable
  include RoleModel

  # do not reorder this array (only add new members to the end)
  roles :admin, :national, :user_manager

  has_paper_trail

  has_many :commitments, inverse_of: :user, dependent: :restrict_with_error
  has_many :identities, inverse_of: :user, dependent: :destroy

  validates :first_name, :last_name, presence: true
  validates :email, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  }

  scope :active, -> { where(suspended: false) }
  scope :suspended, -> { where(suspended: true) }

  strip_attributes collapse_spaces: true

  alias_method :to_s, :name
end
