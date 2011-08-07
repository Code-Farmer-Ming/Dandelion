class CreateMsgQueues < ActiveRecord::Migration
  def self.up
    create_table :msg_queues do |t|
      t.integer :user_id
      t.integer :message_id

      t.timestamps
    end
  end

  def self.down
    drop_table :msg_queues
  end
end
