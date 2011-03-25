class AddDefaultValueForErrorcountInComics < ActiveRecord::Migration
  def self.up
    change_column :comics, :error_count, :integer, :default=>0, :null=>false
  end

  def self.down
    change_column :comics, :error_count, :integer
  end
end
