class AddEmailAndPasswordToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :email, :string
    add_column :users, :password, :string
    add_column :users, :status, :string,:default=>User::STATUS[:reg_step_1]
    add_column :users,:last_position_x,:double,:default=>0
    add_column :users,:last_position_y,:double,:default=>0
  end

  def self.down
    remove_column :users, :password
    remove_column :users, :email
    remove_column :users, :status
    remove_column :users,:last_position_x
    remove_column :users,:last_position_y
  end
end
