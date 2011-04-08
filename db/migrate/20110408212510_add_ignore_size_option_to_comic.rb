class AddIgnoreSizeOptionToComic < ActiveRecord::Migration
  def self.up
    add_column :comics, :ignore_size, :boolean, :default=>false
  end

  def self.down
    remove_column :comics, :ignore_size
  end
end
