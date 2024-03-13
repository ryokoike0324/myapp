class RemoveNotNullFromContractorIdInRequests < ActiveRecord::Migration[7.1]
  def change
    change_column_null :requests, :contractor_id, true
  end
end
