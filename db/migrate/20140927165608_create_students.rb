class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :surname
      t.datetime :birthday
      t.string :student_ip
      t.string :email
      t.belongs_to :student_group
      t.decimal :average_ball, default: 0.0
      t.integer :number_of_semester
      t.text :characteristic

      t.timestamps
    end

    add_index :students, :student_group_id
    add_index :students, :average_ball
    add_index :students, :name
    add_index :students, :number_of_semester

    add_index :students, [
      :student_group_id, :average_ball, :name,
      :number_of_semester, :characteristic, :student_ip
    ], name: 'composite_index_for_filter'
  end
end
