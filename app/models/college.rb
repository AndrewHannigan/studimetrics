class College < ActiveRecord::Base
  belongs_to :user

  def average_score
    self.math + self.critical_reading + self.writing
  end

end
