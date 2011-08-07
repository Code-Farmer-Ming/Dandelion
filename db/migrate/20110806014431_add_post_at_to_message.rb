class AddPostAtToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages,:post_at,:datetime
       
  end

  def self.down
    remove_column :messages,:post_at
  end
end
