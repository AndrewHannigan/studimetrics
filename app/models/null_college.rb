class NullCollege
  def name
    "Dartmouth College"
  end

  def profile_image
    Paperclip::Attachment.new 'fake', self, default_url: '/assets/colleges/profile_images/thumb/missing.png'
  end

  def math
    600
  end

  def writing
    600
  end

  def critical_reading
    600
  end

  def average_score
    1800
  end
end
