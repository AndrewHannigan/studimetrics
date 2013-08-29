class Subject < ActiveRecord::Base
  has_many :sections
  has_many :concepts
  default_scope {order("ordinal asc")}

  scope :not_reading, -> { where(name: ['Math', 'Writing']) }

  def acronym
    words = self.name.split(" ").collect{|word| word.first}
    words = words.collect{|word| word.match(/^[[:alpha:]]$/) ? word.first : nil}.compact
    words.join("").upcase
  end
end
