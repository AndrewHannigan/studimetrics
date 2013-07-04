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

  describe '#correct?' do
    it 'returns true if correct' do
      response = create :user_response
      response.question.expects(:valid_answer?).returns(true)

      expect(response).to be_correct
    end
  end

  describe '_score_response' do
    it 'updates the correct column' do
      response = create :user_response

      expect {
        response.update_attributes value: 'B'
      }.to change{response.correct}.from(true).to(false)
    end

    it 'doesnt update the column if the response is skip' do
      response = create :user_response

      expect {
        response.update_attributes value: Question::SKIP_VALUE
      }.to_not change{response.correct}
    end
  end
end
