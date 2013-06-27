class SectionCompletion < ActiveRecord::Base
  STATUS = ["Completed", "In-Progress"]
  belongs_to :section
  has_many :user_responses
  accepts_nested_attributes_for :user_responses, reject_if: proc { |attributes| attributes['value'].blank? }

  # TODO: should make this a db default of in-progress
  # validates :status, presence: true, inclusion: { in: STATUS, message: "Valid statuses are: #{STATUS.to_sentence}"}

  delegate :name, to: :section, prefix: true
end
