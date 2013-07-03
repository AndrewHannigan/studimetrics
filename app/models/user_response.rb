class UserResponse < ActiveRecord::Base
  belongs_to :question
  belongs_to :section_completion

  def add_time(new_time)
    self.time = time + new_time.to_f
  end

  def time
    super || 0
  end
end
