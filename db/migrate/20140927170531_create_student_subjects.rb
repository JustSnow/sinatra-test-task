class CreateStudentSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :title
    end
  end
end
