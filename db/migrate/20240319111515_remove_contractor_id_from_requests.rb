class RemoveContractorIdFromRequests < ActiveRecord::Migration[7.1]
  def change
    remove_column :requests, :contractor_id, :bigint
  end
end
