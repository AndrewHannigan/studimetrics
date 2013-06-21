class PracticeTest < ActiveRecord::Base
  belongs_to :book
  has_many :sections

  validates :book, :name, presence: true

  def book
    super || NullBook.new
  end

end
