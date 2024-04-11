class AddEngagedToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :engaged, :boolean, default: false, null: false
  end
end
