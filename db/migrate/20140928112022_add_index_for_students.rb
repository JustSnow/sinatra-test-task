class AddIndexForStudents < ActiveRecord::Migration
  def change
    add_index :students, [:student_ip, :characteristic]
    remove_index :students, name: :composite_index_for_filter

    add_index :students, [
      :student_group_id, :average_ball, :name,
      :number_of_semester, :student_ip, :characteristic,
    ], name: 'composite_index_for_filter'
  end
end
