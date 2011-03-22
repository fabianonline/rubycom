class RenameHashToHashValueInStrips < ActiveRecord::Migration
  def self.up
    rename_column :strips, :hash, :hash_value
  end

  def self.down
    rename_column :strips, :hash_value, :hash
  end
end
