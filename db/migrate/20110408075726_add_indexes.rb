class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index(:comics, :name)
    add_index(:strips, :comic_id)
    add_index(:strips, :date)
    add_index(:strips, :hash_value)
  end

  def self.down
    remove_index(:comics, :name)
    remove_index(:strips, :comic_id)
    remove_index(:strips, :date)
    remove_index(:strips, :hash_value)
  end
end
