class RenameApplicationsToRequestApplications < ActiveRecord::Migration[7.1]
  def change
    rename_table :applications, :request_applications
  end
end
