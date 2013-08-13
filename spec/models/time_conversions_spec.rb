require 'spec_helper'

describe TimeConversions do
  describe 'seconds_to_minutes_and_seconds' do
    it 'returns a string representation of minutes and seconds' do
      time_string = TimeConversions.seconds_to_minutes_and_seconds(32)
      expect(time_string).to eq('00:32')

      time_string = TimeConversions.seconds_to_minutes_and_seconds(71)
      expect(time_string).to eq('01:11')
    end
  end

  describe 'seconds_to_hours_and_minutes' do
    it 'returns a string representation of hours and minutes' do
      time_string = TimeConversions.seconds_to_hours_and_minutes(4800)
      expect(time_string).to eq('01:20')

      time_string = TimeConversions.seconds_to_hours_and_minutes(211)
      expect(time_string).to eq('00:03')
    end

    it 'returns 00:00 for time < 1 minute' do
      time_string = TimeConversions.seconds_to_hours_and_minutes(20)
      expect(time_string).to eq('00:00')
    end
  end
end
