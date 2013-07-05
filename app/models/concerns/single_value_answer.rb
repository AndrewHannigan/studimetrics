require 'active_support/concern'

module SingleValueAnswer
  extend ActiveSupport::Concern

  included do
    belongs_to :question
  end

  def valid_answer?(response)
    self.value == response
  end

  def answer
    value
  end

end
