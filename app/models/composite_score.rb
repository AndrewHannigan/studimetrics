class CompositeScore < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject

  def update!

  end
end
