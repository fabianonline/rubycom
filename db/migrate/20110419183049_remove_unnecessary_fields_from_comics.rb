class RemoveUnnecessaryFieldsFromComics < ActiveRecord::Migration
  def self.up
    remove_column :comics, :method
    remove_column :comics, :search_type
    remove_column :comics, :url_scheme
  end

  def self.down
    add_column :comics, :method, :string
    add_column :comics, :search_type, :string
    add_column :comics, :url_scheme, :string
  end
end
