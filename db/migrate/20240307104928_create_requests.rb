class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.string :title, null: false
      t.datetime :deadline, null: false
      t.datetime :delivery_date, null: false
      t.integer :applicants_count, default: 0
      t.text :description, null: false
      t.references :client, null: false, foreign_key: true
      t.references :contractor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
