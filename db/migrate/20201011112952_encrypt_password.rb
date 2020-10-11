class EncryptPassword < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :password
    remove_column :users, :token
    add_column :users, :encrypted_password, :string
    add_column :users, :encrypted_token, :string
  end
end
