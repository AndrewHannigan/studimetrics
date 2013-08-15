module SatDateHelper
  def days_until_sat_registration(date)
    distance_of_time_in_words date - SatDate::REGISTRATION_DIFFERENTIAL, Date.today
  end

  def days_until_sat(date)
    distance_of_time_in_words date, Date.today
  end
end
