# -*- encoding : utf-8 -*-
class AddFieldsForErrorProcessingToComics < ActiveRecord::Migration
  def self.up
    add_column :comics, :status, :string, :default=>"enabled"
    remove_column :comics, :enabled
    add_column :comics, :last_error_message, :string
    add_column :comics, :last_error_at, :datetime
    add_column :comics, :error_count, :integer
  end

  def self.down
    remove_column :comics, :status
    add_column :comics, :enabled, :boolean
    remove_column :comics, :last_error_message
    remove_column :comics, :last_error_at
    remove_column :comics, :error_count
  end
end
