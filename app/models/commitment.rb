class Commitment < ActiveRecord::Base
  has_paper_trail

  belongs_to :user, inverse_of: :commitments

  validates :user, :date, presence: true
  validates :user, uniqueness: {
    scope: [:date, :type],
    message: "can't sign up for the same commitment type twice on the same day"
  }

  def self.to_s
    name.demodulize.underscore.humanize.titleize
  end

  def self.display_text
    self.name.demodulize
  end

  def to_s
    "#{self.class.display_text} on #{date} for #{user}"
  end
end
