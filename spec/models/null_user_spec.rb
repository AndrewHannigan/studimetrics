require 'spec_helper'

describe NullUser do
  describe '#admin?' do
    it 'returns false' do
      expect(NullUser.new.admin?).to be_false
    end
  end

  describe '#projected_total_score' do
    it 'returns nil' do
      expect(NullUser.new.projected_total_score).to be_nil
    end
  end

  describe '#has_watched_concept_video?' do
    it 'returns false' do
      expect(NullUser.new.has_watched_concept_video?(nil)).to be_false
    end
  end
end
