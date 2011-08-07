class CreateAroundMes < ActiveRecord::Migration
  def self.up
    create_table :around_mes do |t|
      t.integer :my_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :around_mes
  end
end
