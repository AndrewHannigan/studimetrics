class Statistic
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def accuracy_for_subject_per_section_completion(subj)
    subject_name = subj.name.titleize.gsub(/\//,' ').gsub(/\s+/, '_').underscore
    section_completion = user.section_completions.completed.last
    return [] unless section_completion
    Rails.cache.fetch("user_accuracy_per_section_completion_and_subject_#{subject_name}_#{section_completion.cache_key}") do
      user.section_completions.completed.send(subject_name).map(&:accuracy)
    end
  end

  def target_subject
    Subject.joins(:composite_scores)
      .where(composite_scores: {user: user})
      .order("composite_scores.composite_score asc").first
  end

end
