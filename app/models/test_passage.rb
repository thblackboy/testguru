class TestPassage < ApplicationRecord
  belongs_to :user
  belongs_to :test
  belongs_to :current_question, class_name: 'Question', optional: true

  before_validation :before_validation_set_current_question

  def accept!(answer_ids)
    self.correct_questions += 1 if correct__answer?(answer_ids)
    save!
  end

  def completed?
    current_question.nil?
  end

  def successful?
    success_ratio >= 85
  end

  def success_ratio
    self.correct_questions.to_f / self.test.questions.count * 100
  end

  def current_question_number
    passed_questions_count + 1
  end

  private

  def correct__answer?(answer_ids)
    answer_ids = [] if answer_ids.nil?
    correct__answers.ids.sort == answer_ids.map(&:to_i).sort
  end

  def correct__answers
    current_question.answers.correct
  end

  def next_question
    if new_record?
      self.current_question = test.questions.first
    else
      test.questions.order(:id).where('id > ?', current_question.id).first
    end
  end

  def passed_questions_count
    test.questions.order(:id).where('id < ?', current_question.id).count
  end

  def before_validation_set_current_question
    self.current_question = next_question
  end
end