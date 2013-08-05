require 'csv'

class QuestionImporter
  attr_accessor :csv

  def initialize(file=Rails.root.join('db', 'questions.csv'))
    self.csv = file
  end

  def import!
    CSV.foreach csv, headers: true do |row|
      question_type = real_question_type_from_row row
      question = Question.create! position: row['number'], question_type: question_type, section_id: row['section_id'], difficulty: row['difficulty']
      add_concepts(question, row)
      add_answers(question, row)
    end
  end

  private

  def add_concepts(question, row)
    concept_ids = [row['topic_1'], row['topic_2'], row['topic_3'], row['topic_4']].reject{|t| t.to_i == 0}
    puts "adding #{concept_ids.length} question concepts for question #{question.inspect}"
    concept_ids.each do |id|
      QuestionConcept.create! question_id: question.id, concept_id: id
    end
  end

  def add_answers(question, row)
    puts "adding #{question.answer_class} answers"

    answers = []
    case question.answer_class.name
    when 'MultipleChoiceAnswer'
      answers << { value: row['mc_answer'] }
    when 'RangeAnswer'
      answers << { min_value: row['fr_min'].to_f, max_value: row['fr_max'].to_f }
    else
      answers = all_possible_answers_in_row(row).map{|a| { value: a } }
    end

    answers.each do |attributes|
      question.answer_class.create! attributes.merge question_id: question.id
    end

  end

  def all_possible_answers_in_row(row)
    [row['fr_min'], row['mfr_1'], row['mfr_2'], row['mfr_3'], row['mfr_4'], row['mfr_5']].reject{|v| v.blank?}.uniq
  end

  def real_question_type_from_row(row)
    real_question_type = case row['question_type']
    when 'free_response'
      if row['fr_min'] != row['fr_max']
        'Range'
      else
        'Free Response'
      end
    when 'multi_free_response'
      'Free Response'
    else
      row['question_type'].titleize
    end
  end

end
