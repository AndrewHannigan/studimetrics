module TimeConversions
  module_function

  def seconds_to_minutes_and_seconds(seconds)
    "#{padded_minutes(seconds)}:#{padded_seconds(seconds)}"
  end

  def seconds_to_hours_and_minutes(seconds)
    adjusted_seconds = seconds%3600
    "#{padded_hours(seconds)}:#{padded_minutes(adjusted_seconds)}"
  end

  def padded_hours(seconds)
    (seconds/3600).floor.to_s.rjust 2, '0'
  end

  def padded_minutes(seconds)
    (seconds/60).floor.to_s.rjust 2, '0'
  end

  def padded_seconds(seconds)
    (seconds%60).floor.to_s.rjust 2, '0'
  end

end
