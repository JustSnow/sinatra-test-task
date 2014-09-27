require 'faker'
require "activerecord-import/base"
require 'ruby-progressbar'
ActiveRecord::Import.require_adapter('postgresql')

STUDENT_GROUP_COUNT = 10
SUBJECT_COUNT = 20
STUDENTS_COUNT = 100

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
    total: STUDENTS_COUNT,
    format: '%t %B %p%% %e'
  })

progressbar_students_subjects =
  ProgressBar.create({
    title: 'Create students <-> subjects',
    total: STUDENTS_COUNT,
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

students =
  [].tap do |a|
    STUDENTS_COUNT.times do |n|
      a << Student.new({
        name: Faker::Name.first_name,
        surname: Faker::Name.last_name,
        birthday: Faker::Business.credit_card_expiry_date,
        student_ip: Faker::Internet.ip_v4_address,
        email: Faker::Internet.free_email,
        student_group: _groups.sample,
        number_of_semester: rand(1..5),
        characteristic: Faker::Lorem.paragraphs(Random.new.rand(5..10)).join("\r\n")
      })
      progressbar_students.increment
    end
  end

Student.import(students)

_students = Student.all

st_subs =
  [].tap do |a|
    _students.find_each do |student|
      tmp =
        [].tap do |b|
          rand(5..10).times do |n|
            b << StudentsSubject.new({
              student: student,
              subject: _subjects.sample,
              ball: rand(1..5)
            })

            b.uniq { |st_s| st_s.subject_id }
          end
        end

      a << tmp
      progressbar_students_subjects.increment
    end
  end

StudentsSubject.import(st_subs.flatten)

progressbar_students_ball =
  ProgressBar.create({
    title: 'Calculate average students ball',
    total: STUDENTS_COUNT,
    format: '%t %B %p%% %e'
  })

_students.find_each do |student|
  student.update_attribute(:updated_at, Time.now)
  progressbar_students_ball.increment
end
