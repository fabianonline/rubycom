# -*- encoding : utf-8 -*-
class AddEnabledToComic < ActiveRecord::Migration
  def self.up
    add_column :comics, :enabled, :boolean, :default=>true
  end

  def self.down
    remove_column :comics, :enabled
  end
end
