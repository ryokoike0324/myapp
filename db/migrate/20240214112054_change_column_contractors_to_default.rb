class ChangeColumnContractorsToDefault < ActiveRecord::Migration[7.1]
  def change
    change_column_default(:contractors, :name, nil)
  end
end
