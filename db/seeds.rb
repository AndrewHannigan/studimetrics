# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admins = [
   {email: "chris@echobind.com", first_name: "Chris", last_name: "Ball"},
   {email: "andrew.s.hannigan@gmail.com", first_name: "Andrew", last_name: "Hannigan"},
   {email: "robert.beene@gmail.com", first_name: "Robert", last_name: "Beene"},
   {email: "ryan.kim@studimetrics.com", first_name: "Ryan", last_name: "Kim"}
]
admins.each do |admin|
  User.create(
    email: admin[:email],
    first_name: admin[:first_name],
    last_name: admin[:last_name],
    password: "test1234",
    city: "Boston",
    state: "MA",
    grade: "12th",
    admin: true)
end

books = []
books << Book.create(
            name: "Example Test Book",
            publisher: Book::PUBLISHERS.sample,
            publish_date: "2013-06-20")

books << Book.create(
            name: "Example Test Book 2",
            publisher: Book::PUBLISHERS.sample,
            publish_date: "2013-02-24")



concepts = []
math_concept = {concepts: []}
math_subject = Subject.create!(name: "Math", ordinal: 1)

math_concept[:concepts] << Concept.create(subject: math_subject, name: "Algebra")
math_concept[:concepts] << Concept.create(subject: math_subject, name: "Geometry")
math_concept[:concepts] << Concept.create(subject: math_subject, name: "Angles on a Plane")
math_concept[:concepts] << Concept.create(subject: math_subject, name: "Properties of Triangles")

writing_subject = Subject.create!(name: "Writing", ordinal: 3)

writing_concept = {concepts: []}
writing_concept[:concepts] << Concept.create(subject: writing_subject, name: "Elements of Writing")
writing_concept[:concepts] << Concept.create(subject: writing_subject, name: "Misplaced Modifiers")

reading_subject = Subject.create!(name: "Reading", ordinal: 2)
reading_concept = {concepts: []}

reading_concept[:concepts] << Concept.create(subject: reading_subject, name: "Comprehension")
reading_concept[:concepts] << Concept.create(subject: reading_subject, name: "Analysis")
reading_concept[:concepts] << Concept.create(subject: reading_subject, name: "Themes")

concepts << math_concept
concepts << writing_concept
concepts << reading_concept

question_types = ["Multiple Choice", "Free Response", "Range", "Multiple Choice", "Multiple Choice", "Multiple Choice"]

books.each do |book|
  5.times do |i|
    practice_test = PracticeTest.create!(book: book, number: i+1)
    8.times do |j|
      concept = concepts.sample[:concepts].sample
      subject = concept.subject
      section = Section.create!(number: j+1, practice_test: practice_test, subject: subject)
      20.times do |k|
        question_type = question_types.sample
        question_concepts = [subject.concepts.sample, subject.concepts.sample].uniq
        question = Question.create!(question_type: question_types.sample, concept_ids: question_concepts.collect(&:id), section: section, position: k+1)

        case question.answer_class.name
          when "MultipleChoiceAnswer"
            value = %w(A B C D E).sample
            answer = question.answer_class.create!(question: question, value: value)
          when "FreeResponseAnswer"
            value = %w(1/5 2/3 5 26 43).sample
            answer = question.answer_class.create!(question: question, value: value)
          when "RangeAnswer"
            min_value, max_value = [[1, 2.5], [2, 5], [4,4.35], [5, 25], [6, 10.5]].sample
            answer = question.answer_class.create!(question: question, min_value: min_value, max_value: max_value)
        end
      end
    end
  end
end

