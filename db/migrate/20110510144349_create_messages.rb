class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :user_id
      t.string :content
      t.integer :position_x
      t.integer :position_y
     
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
