class SectionCompletion < ActiveRecord::Base
  STATUS = ["Completed", "In-Progress"]
  belongs_to :section
  has_many :user_responses
  accepts_nested_attributes_for :user_responses, reject_if: proc { |attributes| attributes['value'].blank? }

  delegate :name, to: :section, prefix: true
end
