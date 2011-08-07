class ChangeMessage < ActiveRecord::Migration
  def self.up
    change_column(:messages,:position_x,:double)
    change_column(:messages,:position_y,:double)

  end

  def self.down
    change_column(:messages,:position_x,:integer)
    change_column(:messages,:position_y,:integer)
  end
end
