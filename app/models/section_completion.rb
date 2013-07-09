class SectionCompletion < ActiveRecord::Base
  STATUS = ["Completed", "In-Progress"]
  belongs_to :section
  belongs_to :user
  has_many :user_responses
  has_many :questions, -> { order 'position asc' }, through: :user_responses

  accepts_nested_attributes_for :user_responses, reject_if: proc { |attributes| attributes['value'].blank? }

  delegate :name, to: :section, prefix: true

  STATUS.each do |status|
    singleton_class.send(:define_method, :"#{status.downcase.underscore}") { where(:status => status) }

    define_method(:"#{status.downcase.underscore}?") { self.status == status }
  end

  def self.for_section_and_user(section, user)
    SectionCompletion.where(section: section, user: user).first || NullSectionCompletion.new
  end

  def started?
    true
  end

  def complete!
    update_attributes status: 'Completed'
  end
end
