class AddOnDeleteCascadeToRequestApplications < ActiveRecord::Migration[7.1]
  def change
    # 外部キー制約を削除
    remove_foreign_key :request_applications, :requests
    # 外部キー制約を再追加（ON DELETE CASCADEオプション付き）
    # on_delete（削除された時に）データに紐づくrequest_applicationsも一緒に削除
    add_foreign_key :request_applications, :requests, on_delete: :cascade
  end
end
