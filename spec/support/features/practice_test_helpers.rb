module Features
  module PracticeTestHelpers
    def section_on_page(section)
      find("[data-id='section-#{section.id}']")
    end

    def question_on_page(question)
      find("[data-id='question-#{question.id}']")
    end

    def correct_icon_for_question(question)
      question_on_page(question).find('.ss-icon')
    end

    def section_link_on_page(section)
      section_on_page(section).find('a')
    end

    def make_radios_visible
      # capybara cant select these if they are display: none
      page.execute_script "$('input.radio_buttons').show()"
      yield
      page.execute_script "$('input.radio_buttons').hide()"
    end

    def visit_and_complete_section(section, user)
      visit new_section_completion_path section_id: section.id,  as: user.id
      start_test

      make_radios_visible do
        section.questions.each do |a_question|
          if a_question.question_type == 'Multiple Choice'
            question_on_page(a_question).choose(MultipleChoiceAnswer::INPUT_CHOICES.sample)
          else
            question_on_page(a_question).set('0.33')
          end
        end
      end

      click_button 'Submit'
    end

    def start_test
      dismiss_modal
      click_link 'play'
    end

    def dismiss_modal
      page.execute_script "$('.reveal-modal-bg').detach()"
      page.execute_script "$('.reveal-modal').detach()"
    end
  end
end
