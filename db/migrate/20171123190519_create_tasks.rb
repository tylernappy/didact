class CreateTasks < ActiveRecord::Migration[5.1]
  def change
      create_table :tasks do |t|
          t.integer :integration_id
          t.integer :user_id
          t.string :name
          t.text :markdown
          t.datetime :due_date
          t.boolean :is_complete
      end
  end
end
