require 'spec_helper'

describe TestCompletion do
  describe '#section_completions' do
    context "user has not retaken the test" do
      it "returns section completions for the user and test" do
        user_response = create :user_response
        user = user_response.section_completion.user
        practice_test = user_response.section_completion.section.practice_test

        test_completion = TestCompletion.new(user: user, practice_test: practice_test)

        expect(test_completion.section_completions).to eq [user_response.section_completion]
      end
    end

    context "user is retaking the test" do
      it "returns only the first section completion for the user and test" do
        user_response = create :user_response

        section_completion = user_response.section_completion
        user = section_completion.user
        practice_test = section_completion.section.practice_test

        section_completion2 = create :section_completion, section_id: section_completion.section_id, user: user

        test_completion = TestCompletion.new(user: user, practice_test: practice_test)

        expect(test_completion.section_completions).to eq [user_response.section_completion]
      end
    end
  end

  describe "#retake_available?" do
    it "calls complete on test progress" do
      user_response = create :user_response
      user = user_response.section_completion.user
      practice_test = user_response.section_completion.section.practice_test

      test_completion = TestCompletion.new(user: user, practice_test: practice_test)

      TestProgress.any_instance.expects(:completed?).returns(true)

      expect(test_completion.retake_available?).to eq true
    end
  end

end
