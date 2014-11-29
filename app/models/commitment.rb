class Commitment < ActiveRecord::Base
  belongs_to :user, inverse_of: :commitments

  validates :user, :date, presence: true
  validates :user, uniqueness: {
    scope: [:date, :type],
    message: "can't sign up for the same commitment type twice on the same day"
  }

  def self.to_s
    name.demodulize.underscore.humanize
  end

  def to_s
    "#{self.class} on #{date} for #{user}"
  end
end
