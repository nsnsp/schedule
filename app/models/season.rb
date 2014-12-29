class Season
  BOUNDARY_MONTH = 5

  attr_reader :starting_year

  def initialize(today = Date.today)
    today = today.to_date
    @starting_year = today.month >= BOUNDARY_MONTH ? today.year : today.year - 1
  end

  # Non-winter months are included in the following season; this is an
  # arbitrary decision that seems to make the most sense, as credit for days
  # worked during non-winter months generally applies to the following winter.
  def date_range
    Date.new(starting_year, BOUNDARY_MONTH, 1)...
      Date.new(starting_year + 1, BOUNDARY_MONTH, 1)
  end

  def include?(date)
    date_range.include?(date.to_date)
  end

  def to_s
    "#{starting_year}/#{starting_year + 1}"
  end
end
