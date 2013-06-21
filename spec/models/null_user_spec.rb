require 'spec_helper'

describe NullUser do
  describe '#first_name' do
    it 'returns Guest' do
      expect(NullUser.new.first_name).to eq('Guest')
    end
  end

  describe '#last_name' do
    it 'returns User' do
      expect(NullUser.new.last_name).to eq('User')
    end
  end

  describe '#admin?' do
    it 'returns false' do
      expect(NullUser.new.admin?).to be_false
    end
  end
end
