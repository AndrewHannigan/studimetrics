class SatDate
  AVAILABLE_DATES = ["01/25", "03/08", "05/03", "06/07", "10/05", "11/02", "12/07"]
  REGISTRATION_DIFFERENTIAL = 29.days

  def self.available_dates_this_year
    AVAILABLE_DATES.map { |d| Date.parse d, Date.today }
  end

  def self.remaining_dates_this_year
    available_dates_this_year.select { |d| d > Date.today }
  end

  def self.upcoming_dates
    upcoming_dates = available_dates_this_year.map { |d| date_or_next_year_if_already_passed d }
    upcoming_dates.sort
  end

  private

  def self.date_or_next_year_if_already_passed(date)
    if date <= Date.today
      date + 1.year
    else
      date
    end
  end
end
