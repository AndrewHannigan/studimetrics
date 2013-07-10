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
end
