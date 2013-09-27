class College < ActiveRecord::Base
  include ProfileImage

  has_many :users
  after_save :touch_users

  def average_score
    average_math + average_critical_reading + average_writing
  end

  def average_math
    score = ((low_percentile_math + high_percentile_math)/2).floor
    (score % 10) + score
  end

  def average_critical_reading
    score = ((low_percentile_critical_reading + high_percentile_critical_reading)/2).floor
    (score % 10) + score
  end

  def average_writing
    score = ((low_percentile_writing + high_percentile_writing)/2).floor
    (score % 10) + score
  end

  def range_for_subject(subject)
    {low: send("low_percentile_#{subject}"), average: send("average_#{subject}"), high: send("high_percentile_#{subject}")}
  end

  def active_model_serializer
    CollegeSerializer
  end

  private

  # TODO: put this into a background task
  def touch_users
    users.each {|u| u.touch}
  end

end
