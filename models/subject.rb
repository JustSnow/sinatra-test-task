class Subject < ActiveRecord::Base
  has_many :students_subjects, dependent: :destroy
  has_many :students, through: :students_subjects

  validates :title, presence: true
end
