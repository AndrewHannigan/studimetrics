class NullUser
  attr_reader :email, :first_name, :last_name, :full_name

  def admin
    false
  end
  alias_method :admin?, :admin

  def projected_total_score
    nil
  end

  def has_watched_concept_video?(concept_video)
    false
  end

  def active?
    false
  end

end
