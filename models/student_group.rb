class StudentGroup < ActiveRecord::Base
  has_many :students

  validates :title, presence: true
end
