class AddEngagedToContractors < ActiveRecord::Migration[7.1]
  def change
    add_column :contractors, :engaged, :boolean, default: false, null: false
  end
end
