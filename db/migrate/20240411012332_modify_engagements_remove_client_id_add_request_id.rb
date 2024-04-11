class ModifyEngagementsRemoveClientIdAddRequestId < ActiveRecord::Migration[7.1]
  def change
    remove_reference :engagements, :client, index: true, foreign_key: true
    add_reference :engagements, :request, null: false, foreign_key: true
  end
end
