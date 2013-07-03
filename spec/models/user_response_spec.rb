require 'spec_helper'

describe UserResponse do
  describe '#add_time' do
    it 'adds time to an existing response' do
      response = UserResponse.new time: 1.2
      response.add_time 1.3

      expect(response.time).to eq(2.5)
    end

    it 'adds time to a new response' do
      response = UserResponse.new
      response.add_time 1.3

      expect(response.time).to eq(1.3)
    end

    it 'takes a string representation of a decimal' do
      response = UserResponse.new time: 1
      response.add_time '1.75'

      expect(response.time).to eq(2.75)
    end
  end
end
