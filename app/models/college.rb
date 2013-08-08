class College < ActiveRecord::Base
  include ProfileImage

  belongs_to :user

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

end
