class SatDate
  AVAILABLE_DATES = ["2014-01-25", "2014-03-08", "2014-05-03", "2014-06-07", "2013-10-05", "2013-11-02", "2013-12-07"]
  REGISTRATION_DIFFERENTIAL = 29.days

#  def self.available_dates_this_year
#    AVAILABLE_DATES.map { |d| Date.parse d, Date.today }
#  end
#
#  def self.remaining_dates_this_year
#    available_dates_this_year.select { |d| d > Date.today }
#  end

  def self.upcoming_dates
    all_dates = AVAILABLE_DATES.map { |d| Date.parse d }
    upcoming_dates = all_dates.select { |d| d > Date.today }  
    upcoming_dates.sort
  end

#  private
#
#  def self.date_or_next_year_if_already_passed(date)
#    if date <= Date.today
#      date + 1.year
#    else
#      date
#    end
#  end
end
