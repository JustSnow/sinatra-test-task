require 'memoist'

class IndexPresenter
  extend Memoist

  cattr_accessor :params
  cattr_accessor :students

  def initialize(opts = {})
    self.params = opts
    self.students = Student.includes(:student_group, students_subjects: :subject)
  end

  def filter_groups
    self.students = students.by_group(params[:student_group_id]) if params[:student_group_id].present?
  end

  def filter_average_ball
    self.students = students.by_average_ball(params[:ball_from], params[:ball_to]) if params[:ball_from].present? || params[:ball_to].present?
  end

  def filter_name
    self.students = students.by_name(params[:student_name]) if params[:student_name].present?
  end

  def filter_semester
    self.students = students.by_semester(params[:semester]) if params[:semester].present?
  end

  def filter_ip
    self.students = students.by_ip_with_cahracteristic(params[:student_ip]) if params[:student_ip].present?
  end

  def with_paginate
    students.paginate(page: params[:page], per_page: 50)
  end

  def all_scoup
    filter_groups
    filter_average_ball
    filter_name
    filter_semester
    filter_ip

    with_paginate
  end

  memoize :filter_groups, :filter_average_ball, :filter_name, :filter_semester,
    :filter_ip, :with_paginate, :all_scoup
end
