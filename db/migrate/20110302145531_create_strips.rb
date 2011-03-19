class CreateStrips < ActiveRecord::Migration
  def self.up
    create_table :strips do |t|
      t.integer     :comic_id
      t.datetime    :date
      t.string      :url
      t.string      :hash
      t.string      :title_tag
      t.string      :alt_tag
      t.timestamps
    end
  end

  def self.down
    drop_table :strips
  end
end
