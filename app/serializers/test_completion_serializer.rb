class TestCompletionSerializer < ActiveModel::Serializer
  attributes :id, :practice_test_name, :total_score, :math_score, :critical_reading_score, :writing_score, :user_id, :created_at

  def math_score
    object.math_score || 0
  end

  def critical_reading_score
    object.critical_reading_score || 0
  end

  def writing_score
    object.writing_score || 0
  end

  def total_score
    object.total || 0
  end
end
