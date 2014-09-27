require 'sinatra'
require 'sinatra/activerecord'
require 'haml'
require "activerecord-import/base"
require 'will_paginate'
require 'will_paginate/active_record'
require 'will_paginate-bootstrap'
ActiveRecord::Import.require_adapter('postgresql')

Dir.glob('./models/*.rb').each { |r| require r }

set :haml, { format: :html5, attr_wrapper: '"' }

get "/" do
  @students = Student.includes(:student_group, students_subjects: :subject).limit(10)

  @students = @students.by_group(params[:student_group_id]) if params[:student_group_id].present?

  @students =
    @students.by_average_ball(params[:ball_from], params[:ball_to]) if params[:ball_from].present? || params[:ball_to].present?

  @students = @students.by_name(params[:student_name]) if params[:student_name].present?
  @students = @students.by_semester(params[:semester]) if params[:semester].present?
  @students = @students.by_ip_with_cahracteristic(params[:student_ip]) if params[:student_ip].present?

  @students = @students.paginate(page: params[:page], per_page: 10)

  @student_groups = StudentGroup.all

  haml :index
end

get '/students/new' do
  @student_groups = StudentGroup.all
  haml :new
end

get '/students/best' do
  @best_students = Student.best
  haml :best
end

post '/students/new' do
  @student = Student.new(params[:student])

  if @student.save
    @subjects = Subject.all

    st_subs =
      [].tap do |a|
        rand(2..6).times do |n|
          a << StudentsSubject.new(student: @student, subject: @subjects.sample, ball: rand(1..5))
        end
      end

    StudentsSubject.import(st_subs)

    redirect '/'
  else
    haml :new
  end
end
