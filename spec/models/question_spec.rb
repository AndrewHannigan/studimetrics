require 'spec_helper'

describe Question do
  describe 'validations' do
    it 'must have a unique name per section id' do
     question = FactoryGirl.create :question
     expect {
      FactoryGirl.create! :question, section: question.section
     }.to raise_error
    end
  end
end
