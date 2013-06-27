require 'spec_helper'

describe NullUser do
  describe '#admin?' do
    it 'returns false' do
      expect(NullUser.new.admin?).to be_false
    end
  end
end
