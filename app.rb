require 'sinatra'
require 'sinatra/activerecord'
require 'haml'
require "activerecord-import/base"
require 'will_paginate'
require 'will_paginate/active_record'
require 'will_paginate-bootstrap'

ActiveRecord::Import.require_adapter('postgresql')

Dir.glob('./models/*.rb').each { |r| require r }
Dir.glob('./presenters/*.rb').each { |r| require r }

set :haml, {
  format: :html5,
  attr_wrapper: '"'
}

get "/" do
  @students       = IndexPresenter.new(params).all_scoup
  @student_groups = StudentGroup.all

  haml :index, layout: !request.xhr?
end

get '/students/new' do
  @student_groups = StudentGroup.all
  haml :new, layout: !request.xhr?
end

get '/students/best' do
  @best_students = Student.best
  haml :best, layout: !request.xhr?
end

post '/students/new' do
  @student = Student.new(params[:student])

  if @student.save
    subjects = Subject.all

    st_subs =
      [].tap do |a|
        rand(2..6).times do |n|
          a << StudentsSubject.new(student: @student, subject: subjects.sample, ball: rand(1..5))
        end
      end

    StudentsSubject.import(st_subs)
    @student.send(:calculate_average_ball)

    @students       = IndexPresenter.new(params).with_paginate
    @student_groups = StudentGroup.all

    haml :index, layout: !request.xhr?
  else
    if request.xhr?
     status 500
    else
      haml :new
    end
  end
end

get '/students/:id/edit' do
  @student = Student.find(params[:id])
  @student_groups = StudentGroup.all
  haml :edit, layout: !request.xhr?
end

post '/students/:id/update' do
  @student = Student.find(params[:id])

  if @student.update_attributes(params[:student])
    @students       = IndexPresenter.new(params).with_paginate
    @student_groups = StudentGroup.all

    haml :index, layout: !request.xhr?
  else
    if request.xhr?
     status 500
    else
      haml :edit
    end
  end
end
