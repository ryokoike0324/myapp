class CreateEngagements < ActiveRecord::Migration[7.1]
  def change
    create_table :engagements do |t|
      t.references :client, null: false, foreign_key: true
      t.references :contractor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
