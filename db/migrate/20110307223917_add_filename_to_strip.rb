class AddFilenameToStrip < ActiveRecord::Migration
  def self.up
    add_column :strips, :filename, :string
  end

  def self.down
    remove_column :strips, :filename
  end
end
