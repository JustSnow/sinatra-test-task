require 'faker'
require "activerecord-import/base"
require 'ruby-progressbar'
ActiveRecord::Import.require_adapter('postgresql')

STUDENT_GROUP_COUNT = 10
SUBJECT_COUNT = 50
STUDENTS_COUNT = 1000
STUDENTS_FACTOR = 1000

progressbar_student_groups =
  ProgressBar.create({
    title: 'Create student_groups',
    total: STUDENT_GROUP_COUNT,
    format: '%t %B %p%% %e'
  })

progressbar_subjects =
  ProgressBar.create({
    title: 'Create subjects',
    total: SUBJECT_COUNT,
    format: '%t %B %p%% %e'
  })

progressbar_students =
  ProgressBar.create({
    title: 'Create students',
    total: STUDENTS_FACTOR,
    format: '%t %B %p%% %e'
  })

progressbar_students_subjects =
  ProgressBar.create({
    title: 'Generate relashion students <-> subjects',
    total: STUDENTS_FACTOR,
    format: '%t %B %p%% %e'
  })

student_groups =
  [].tap do |a|
    STUDENT_GROUP_COUNT.times do |n|
      a << StudentGroup.new(title: Faker::Lorem.sentence)
      progressbar_student_groups.increment
    end
  end

StudentGroup.import(student_groups)

subjects =
  [].tap do |a|
    SUBJECT_COUNT.times do |n|
      a << Subject.new(title: Faker::Lorem.sentence)
      progressbar_subjects.increment
    end
  end

Subject.import(subjects)

_subjects = Subject.all
_groups   = StudentGroup.all

STUDENTS_FACTOR.times do |n|
  students =
    [].tap do |a|
      STUDENTS_COUNT.times do |n|
        characteristics = [nil, Faker::Lorem.paragraphs(Random.new.rand(2..5)).join("\r\n")]

        a << Student.new({
          name: Faker::Name.first_name,
          surname: Faker::Name.last_name,
          birthday: Faker::Business.credit_card_expiry_date,
          student_ip: Faker::Internet.ip_v4_address,
          email: Faker::Internet.free_email,
          student_group: _groups.sample,
          number_of_semester: rand(1..5),
          characteristic: characteristics.sample
        })
      end
    end

  Student.import(students)
  progressbar_students.increment
end

_students = Student.all.order(id: :desc)

STUDENTS_FACTOR.times do |n|
  st_subs =
    [].tap do |a|
      _students.limit(STUDENTS_COUNT).offset(n * STUDENTS_FACTOR).each do |student|
        a <<
          [].tap do |b|
            rand(3..5).times do |n|
              b << StudentsSubject.new({
                student: student,
                subject: _subjects.sample,
                ball: rand(1..5)
              })

              b.uniq { |st_s| st_s.subject_id }
            end
          end
      end
    end

  StudentsSubject.import(st_subs.flatten)
  progressbar_students_subjects.increment
end

progressbar_students_ball =
  ProgressBar.create({
    title: 'Calculate average students ball',
    total: _students.size,
    format: '%t %B %p%% %e'
  })

_students.find_each do |student|
  student.send(:calculate_average_ball)
  progressbar_students_ball.increment
end
