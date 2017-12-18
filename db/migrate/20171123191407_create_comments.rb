class CreateComments < ActiveRecord::Migration[5.1]
  def change
      create_table :comments do |t|
          t.integer :task_id
          t.integer :integration_id
          t.integer :user_id
          t.text :markdown
      end
  end
end
