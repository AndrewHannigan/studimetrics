class Subject < ActiveRecord::Base
  has_many :sections
  has_many :concepts
end
