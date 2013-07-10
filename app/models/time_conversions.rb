module TimeConversions
  module_function

  def seconds_to_minutes_and_seconds(seconds)
    "#{padded_minutes(seconds)}:#{padded_seconds(seconds)}"
  end

  def padded_minutes(seconds)
    (seconds/60).floor.to_s.rjust 2, '0'
  end

  def padded_seconds(seconds)
    (seconds%60).floor.to_s.rjust 2, '0'
  end
end
