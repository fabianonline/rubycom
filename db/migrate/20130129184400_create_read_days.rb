# -*- encoding : utf-8 -*-
class CreateReadDays < ActiveRecord::Migration
  def self.up
    create_table :read_days do |t|
      t.date :day
    end
  end

  def self.down
    drop_table :read_days
  end
end
