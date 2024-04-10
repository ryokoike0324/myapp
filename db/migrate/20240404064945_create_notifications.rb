class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :sender, polymorphic: true, null: false
      t.references :recipient, polymorphic: true, null: false
      # 将来的に通知するイベントが増えたときに備えてポリモーフィックスを使う
      t.references :event, polymorphic: true, null: false
      # 既読かどうかを判別する
      t.boolean :unread, default: true

      t.timestamps
    end
  end
end
