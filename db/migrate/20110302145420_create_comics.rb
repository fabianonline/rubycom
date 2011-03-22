class CreateComics < ActiveRecord::Migration
  def self.up
    create_table :comics do |t|
      t.string    :name
      t.string    :base_url
      t.string    :method
      t.string    :search_type
      t.string    :search_query
      t.string    :url_scheme
      t.string    :directory
      t.timestamps
    end
  end

  def self.down
    drop_table :comics
  end
end
