class RemoveAppliedFromContractors < ActiveRecord::Migration[7.1]
  def change
    remove_column :contractors, :applied, :boolean
  end
end
