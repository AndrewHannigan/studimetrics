class PracticeTest < ActiveRecord::Base
  belongs_to :book
  has_many :sections

  validates :book, :name, presence: true
  delegate :name, to: :book, prefix: true

  def book
    super || NullBook.new
  end

  def name
    "Test #{number}"
  end

end
