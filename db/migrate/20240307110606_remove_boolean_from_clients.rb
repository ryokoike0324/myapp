class RemoveBooleanFromClients < ActiveRecord::Migration[7.1]
  def change
    remove_column :clients, :boolean, :string
  end
end
