class CreateStudentsSubjects < ActiveRecord::Migration
  def change
    create_table :students_subjects do |t|
      t.belongs_to :student
      t.belongs_to :subject
      t.integer :ball, default: 0
    end

    add_index :students_subjects, :student_id
    add_index :students_subjects, :subject_id
  end
end
