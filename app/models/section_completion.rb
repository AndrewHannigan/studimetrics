class SectionCompletion < ActiveRecord::Base
  STATUS = ["Completed", "In-Progress"]
  belongs_to :section
  has_many :responses

  validates :status, presence: true, inclusion: { in: STATUS, message: "Valid statuses are: #{STATUS.to_sentence}"}
end
