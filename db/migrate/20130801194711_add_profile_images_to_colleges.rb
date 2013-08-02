class AddProfileImagesToColleges < ActiveRecord::Migration
  def change
    add_attachment :colleges, :profile_image
  end
end
