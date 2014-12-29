class Commitment < ActiveRecord::Base
  has_paper_trail

  belongs_to :user, inverse_of: :commitments

  validates :user, :date, presence: true
  validates :user, uniqueness: {
    scope: :date,
    message: "can't sign up twice on the same day"
  }

  def self.to_s
    name.demodulize.underscore.humanize.titleize
  end

  def self.display_text
    self.name.demodulize
  end

  def self.display_verb
    display_text
  end

  def self.day_multiplier
    1
  end

  def self.last_frozen_date
    Date.tomorrow
  end

  def self.frozen?(date)
    date.to_date <= last_frozen_date
  end

  def self.unavailable?(date)
    frozen?(date.to_date) || !Season.new.include?(date)
  end

  def to_s
    "#{self.class.display_text} on #{date} for #{user}"
  end

  def to_date
    date
  end

  def bootstrap_class_suffix
    self.class.bootstrap_class_suffix
  end

  def display_color
    self.class.display_color
  end

  def display_text
    self.class.display_text
  end

  def display_verb
    self.class.display_verb
  end

  def frozen?
    self.class.frozen?(self)
  end

end
