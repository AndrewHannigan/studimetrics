class UserResponse < ActiveRecord::Base
  belongs_to :question
  belongs_to :section_completion
end
