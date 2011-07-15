class AddPasswordToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :encryped_password:string
  end

  def self.down
    remove_column :users, :encryped_password
  end
end
