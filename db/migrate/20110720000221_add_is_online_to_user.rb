class AddIsOnlineToUser < ActiveRecord::Migration
  def self.up
    add_column :users,:is_online,:boolean,:default=>false
  end

  def self.down
    remove_column :users,:is_online
  end
end
