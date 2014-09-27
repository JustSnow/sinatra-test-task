class StudentsSubject < ActiveRecord::Base
  belongs_to :student
  belongs_to :subject

  validates :student, :subject, :ball, presence: true

  delegate :title, to: :subject, prefix: true
end
