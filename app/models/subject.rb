class Subject < ActiveRecord::Base
  has_many :sections
  has_many :concepts

  def acronym
    words = self.name.split(" ").collect{|word| word.first}
    words = words.collect{|word| word.match(/^[[:alpha:]]$/) ? word.first : nil}.compact
    words.join("").upcase
  end
end
