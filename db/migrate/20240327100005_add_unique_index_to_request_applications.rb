class AddUniqueIndexToRequestApplications < ActiveRecord::Migration[7.1]
  def change
    # contractor_idとrequest_idの組み合わせにユニークインデックスを追加
    add_index :request_applications, [:contractor_id, :request_id], unique: true
  end
end
