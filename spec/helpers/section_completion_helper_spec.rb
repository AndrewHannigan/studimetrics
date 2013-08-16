require 'spec_helper'

describe SectionCompletionHelper do
  describe 'user_points_with_indicator' do
    it 'renders a plus and the points if positive' do
      SectionCompletion.stubs(:points_for_user_and_subject).returns(200)
      expect(helper.user_points_with_indicator(User.new, 'math')).to eq("+200")
    end

    it 'renders a minus and the points if negative' do
      SectionCompletion.stubs(:points_for_user_and_subject).returns(-1200)
      expect(helper.user_points_with_indicator(User.new, 'math')).to eq("-1200")
    end
  end

end
