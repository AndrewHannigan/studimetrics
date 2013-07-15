class QuestionConcept < ActiveRecord::Base
  belongs_to :question
  belongs_to :concept
end
