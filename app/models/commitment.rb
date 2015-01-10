class Commitment < ActiveRecord::Base
  LOCAL_FREEZE_HOUR = 4

  has_paper_trail

  belongs_to :user, inverse_of: :commitments

  validate :day_not_frozen, on: :create
  validates :date, inclusion: {
    in: Season.new.date_range,
    message: "is not in the #{Season.new} season"
  }, on: :create
  validates :user, :date, :uuid, presence: true
  validates :user, uniqueness: {
    scope: :date,
    message: "can't sign up twice on the same day"
  }

  after_initialize :set_defaults
  before_destroy :verify_destruction_allowed

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

  def self.frozen?(date)
    Time.now > date.to_date.to_time + LOCAL_FREEZE_HOUR.hours
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

  def set_defaults
    self.uuid ||= SecureRandom.uuid.upcase
  end

  private

  def verify_destruction_allowed
    return true unless frozen?
    errors[:base] <<
      "It's too late to cancel for #{date.strftime('%A, %-m/%-d/%y')}"
    false
  end

  def day_not_frozen
    message = "It's too late to sign up for #{date.strftime('%A, %-m/%-d/%y')}"
    errors[:base] << message if frozen?
  end

end
