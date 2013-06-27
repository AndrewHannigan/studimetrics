class NullUser
  attr_accessor :email, :first_name, :last_name, :full_name

  def admin
    false
  end
  alias_method :admin?, :admin

end
