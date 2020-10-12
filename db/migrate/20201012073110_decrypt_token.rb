class DecryptToken < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :encrypted_token_iv
    remove_column :users, :encrypted_token
    add_column :users, :token, :string
  end
end
