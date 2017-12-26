class CreateIntegrations < ActiveRecord::Migration[5.1]
  def change
      create_table :integrations do |t|
          t.integer :user_id
          t.string :name
          t.string :company
          t.datetime :due_date
          t.boolean :is_complete
      end
  end
end
