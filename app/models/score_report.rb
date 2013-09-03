class ScoreReport

  attr_accessor :user
  delegate :full_name, to: :user
  delegate :college, to: :user
  delegate :total_seconds_studied, to: :user
  delegate :sat_date, to: :user

  include ApplicationHelper
  include SatDateHelper
  include ConceptHelper
  include ActionView::Helpers::DateHelper

  def initialize(user)
    @user = user
  end

  def current_user
    user
  end

  def timeframe
    "#{Time.now.beginning_of_week.strftime '%m/%d/%y'} - #{Time.now.end_of_week.strftime '%m/%d/%y'}"
  end

  def profile_image
    user.profile_image.url(:thumb)
  end

  def math_score
    math = Subject.where(name: 'Math').first
    projected_score_for_subject(math)
  end

  def reading_score
    reading = Subject.where(name: 'Reading').first
    projected_score_for_subject(reading)
  end

  def writing_score
    writing = Subject.where(name: 'Writing').first
    projected_score_for_subject(writing)
  end

  def total_seconds_studied_this_week
    0
  end

  def percentile_in_words(subject_name)
    percentiles = college.range_for_subject subject_name
    subject_name.gsub! 'critical_', ''
    score = send("#{subject_name}_score").to_i

    if score > percentiles[:high].to_i
      "Above"
    elsif (percentiles[:low].to_i..percentiles[:high].to_i).include? score
      "Within"
    else
      "Below"
    end
  end

  def target_concepts
    target_concept_ids = FocusRank.target_concepts_for_user(current_user).collect(&:concept_id)
    Concept.where(id: target_concept_ids)
  end

end
