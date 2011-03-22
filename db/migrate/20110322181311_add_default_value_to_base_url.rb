class AddDefaultValueToBaseUrl < ActiveRecord::Migration
  def self.up
    change_column :comics, :base_url, :string, :default=>"http://"
  end

  def self.down
    change_column :comics, :base_url, :string
  end
end
