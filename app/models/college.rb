class College < ActiveRecord::Base
  include ProfileImage

  belongs_to :user

  def average_score
    self.math + self.critical_reading + self.writing
  end

end
