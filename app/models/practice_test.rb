class PracticeTest < ActiveRecord::Base
  belongs_to :book

  validates :book, :name, presence: true

  def book
    super || NullBook.new
  end

end
