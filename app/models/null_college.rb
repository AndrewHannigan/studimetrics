class NullCollege
  def name
    "No College"
  end

  def profile_image
    Paperclip::Attachment.new 'fake', self, default_url: 'http://s3.amazonaws.com/studimetrics-production/colleges/profile_images/thumb/missing.png'
  end

  def average_score
    0
  end

  def average_math
    0
  end

  def average_writing
    0
  end

  def average_critical_reading
    0
  end

end
