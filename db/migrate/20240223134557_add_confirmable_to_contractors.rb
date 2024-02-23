class AddConfirmableToContractors < ActiveRecord::Migration[7.1]
  def change
    add_column :contractors, :confirmation_token, :string
    add_column :contractors, :confirmed_at, :datetime
    add_column :contractors, :confirmation_sent_at, :datetime
    add_column :contractors, :unconfirmed_email, :string
  end
end
