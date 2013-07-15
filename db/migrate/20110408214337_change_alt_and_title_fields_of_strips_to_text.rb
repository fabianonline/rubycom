# -*- encoding : utf-8 -*-
class ChangeAltAndTitleFieldsOfStripsToText < ActiveRecord::Migration
  def self.up
    change_column :strips, :title_tag, :text
    change_column :strips, :alt_tag, :text
  end

  def self.down
    change_column :strips, :title_tag, :string
    change_column :strips, :alt_tag, :string
  end
end
