require 'spec_helper'

describe NullSectionCompletion do
  context "#status" do
    it "returns Not Started" do
      null_section_completion = NullSectionCompletion.new

      expect(null_section_completion.status).to eq "Not Started"
    end
  end
end
