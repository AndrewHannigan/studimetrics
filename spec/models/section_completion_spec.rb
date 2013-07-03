require 'spec_helper'

describe SectionCompletion do
  context "#for_section_and_user" do
    context "when the section completion doesn't exist" do
      it "returns a null section completion object" do
        section = create :section
        user    = create :user

        section_completion = SectionCompletion.for_section_and_user(section, user)

        expect(section_completion.class).to eq NullSectionCompletion
      end
    end

    context "when the section completion exists" do
      it "returns a section completion" do
        
      end
    end
  end
end
