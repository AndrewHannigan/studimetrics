class NullSectionCompletion
  attr_accessor :section
  delegate :name, to: :section, prefix: true

  def initialize(section=nil)
    self.section = section
  end

  def status
    "Not Started"
  end

  def in_progress?
    false
  end

  def completed?
    false
  end
end
