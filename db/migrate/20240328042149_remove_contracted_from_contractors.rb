class RemoveContractedFromContractors < ActiveRecord::Migration[7.1]
  def change
    remove_column :contractors, :contracted, :boolean
  end
end
