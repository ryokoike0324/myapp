class CreateFavorites < ActiveRecord::Migration[7.1]
  def change
    create_table :favorites do |t|
      t.references :contractor, null: false, foreign_key: true
      t.references :request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
