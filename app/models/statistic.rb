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
      .order("composite_scores.composite_score asc").first || Subject.first
  end

  def next_available_section_for_target_subject
    return nil unless target_subject
    Rails.cache.fetch("next_section_for_target_subject_and_user_#{user.id}") do
      preferred_section_id_for_subject(target_subject) || incomplete_section_ids_for_subject(target_subject).first
    end
  end

  private
    def section_ids_for_subject_in_current_test(subj)
      return [] unless user.current_test
      Section.joins(:practice_test)
        .where(practice_tests: {id: user.current_test.id})
        .where(sections: {subject_id: subj.id})
        .pluck(:id)
    end

    def preferred_section_id_for_subject(subj)
      priority_ids = section_ids_for_subject_in_current_test(subj) - completed_section_ids
      priority_ids.select{|section_id| section_ids_for_subject(subj).include?(section_id)}.first
    end


    def completed_section_ids
      SectionCompletion.completed.where(user_id: user.id).pluck(:section_id)
    end

    def incomplete_section_ids_for_subject(subj)
      section_ids_for_subject(subj) - completed_section_ids
    end

    def section_ids_for_subject(subject)
      subject.section_ids
    end
end
