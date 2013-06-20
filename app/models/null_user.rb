class NullUser
  attr_accessor :email

  def first_name
    'Guest'
  end

  def last_name
    'User'
  end

  def admin
    false
  end
  alias_method :admin?, :admin

end
