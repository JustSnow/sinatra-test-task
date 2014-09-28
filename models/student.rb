class Student < ActiveRecord::Base
  before_save :generate_number_of_semester, unless: :number_of_semester?
  after_save :calculate_average_ball

  scope :best, -> { order(average_ball: :desc).limit(10) }
  scope :by_group, ->(group_id) { where(student_group_id: group_id) }
  scope :by_name, ->(st_name) { where('name ILIKE :text', text: "%#{ st_name }%") }
  scope :by_semester, ->(semester) { where(number_of_semester: semester) }
  scope :by_ip_with_cahracteristic, ->(ip) { where(student_ip: ip).where.not(characteristic: nil) }
  scope :by_average_ball, ->(from = nil, to = nil) {
    if from.present? && to.present?
      where(average_ball: from..to)
    elsif from.present?
      where(average_ball: from)
    else
      where(average_ball: to)
    end
  }

  belongs_to :student_group

  has_many :students_subjects, dependent: :destroy
  has_many :subjects, through: :students_subjects

  validates :name, :email, presence: true

  accepts_nested_attributes_for :students_subjects, allow_destroy: true, reject_if: :all_blank

  delegate :title, to: :student_group, prefix: true

  def full_name
    "#{ name } #{ surname }"
  end

  private

  def calculate_average_ball
    update_column(:average_ball, sprintf('%.2f', students_subjects.average(:ball) || 0))
  end

  def generate_number_of_semester
    self.number_of_semester = rand(1..5)
  end
end
