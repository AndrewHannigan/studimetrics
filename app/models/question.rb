class Question < ActiveRecord::Base
  belongs_to :section

  validates :name, presence: true, uniqueness: { scope: :section_id }
end
