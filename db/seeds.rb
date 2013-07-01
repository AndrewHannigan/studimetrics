# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.create(
            email: "admin@example.com",
            first_name: "Admin",
            last_name: "User",
            password: "test1234",
            city: "Boston",
            state: "MA",
            grade: "12th",
            admin: true)

user = User.create(
            email: "user@example.com",
            first_name: "Test",
            last_name: "User",
            password: "test1234",
            city: "Boston",
            state: "MA",
            grade: "9th",
            admin: false)

book = Book.create(
            name: "Example Test Book",
            publisher: Book::PUBLISHERS.first,
            publish_date: "2013-06-20")

subject = Subject.create(name: "Math")
test = PracticeTest.create(book: book, number: 1)

section = Section.create(number: 1, practice_test: test, subject: subject)

multiple_choice_question = Question.create!(
  question_type: "Multiple Choice",
  section: section,
  position: 1)

MultipleChoiceAnswer.create!(
  question: multiple_choice_question,
  value: "A")

range_question = Question.create!(
  question_type: "Range",
  section: section,
  position: 2)

RangeAnswer.create!(
  question: range_question,
  min_value: 1,
  max_value: 10)


