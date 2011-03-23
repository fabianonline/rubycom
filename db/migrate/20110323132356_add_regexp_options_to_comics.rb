class AddRegexpOptionsToComics < ActiveRecord::Migration
  def self.up
    add_column :comics, :regexp_search, :string
    add_column :comics, :regexp_replace, :string
  end

  def self.down
    remove_column :comics, :regexp_replace
    remove_column :comics, :regexp_search
  end
end
