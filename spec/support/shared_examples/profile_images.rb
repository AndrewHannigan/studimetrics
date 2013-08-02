shared_examples "a profile image" do
  it "has one" do
    expect(described_class.new).to have_attached_file(:profile_image)
  end
end
