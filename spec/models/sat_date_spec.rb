require 'spec_helper'

describe SatDate do
#  describe '.available_dates_this_year' do
#    it 'returns an array of dates for this year' do
#      year = Date.today.year
#      SatDate.available_dates_this_year.each_with_index do |date, index|
#        expect(date.to_s).to eq "#{SatDate::AVAILABLE_DATES[index]}/#{year}"
#      end
#    end
#  end
#
#  describe '.remaining_dates_this_year' do
#    it 'returns the remaining dates for this year' do
#      Timecop.travel Time.local(2013, 5, 1) do
#        today = Date.today
#        SatDate.remaining_dates_this_year.each_with_index do |date, index|
#          expect(date).to be > today
#        end
#      end
#    end
#  end

  describe '.upcoming_dates' do
    it 'returns all future SAT dates' do
      Timecop.travel Time.local(2013, 7, 5) do
        dates = SatDate.upcoming_dates
        expect(dates[0].to_s).to eq '01/25/2014'
        expect(dates[1].to_s).to eq '03/08/2014'
        expect(dates[2].to_s).to eq '05/03/2014'
        expect(dates[3].to_s).to eq '06/07/2014'
      end
    end
  end
end
