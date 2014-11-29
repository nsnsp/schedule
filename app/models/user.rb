class User < ActiveRecord::Base
  has_many :commitments, inverse_of: :user

  validates :first_name, :last_name, presence: true
  validates :email, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  }

  strip_attributes collapse_spaces: true

  def name
    "#{first_name} #{last_name}"
  end

  def to_s
    name
  end
end
