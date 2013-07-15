# -*- encoding : utf-8 -*-
class AddBytesToStrip < ActiveRecord::Migration
  def self.up
    add_column :strips, :bytes, :integer
  end

  def self.down
    remove_column :strips, :bytes
  end
end
