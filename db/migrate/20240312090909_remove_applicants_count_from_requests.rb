class RemoveApplicantsCountFromRequests < ActiveRecord::Migration[7.1]
  def change
    remove_column :requests, :applicants_count, :integer
  end
end
