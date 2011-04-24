class AddUrlsToUpload < ActiveRecord::Migration
  def self.up
		add_column :uploads, :display, :string
		add_column :uploads, :direct, :string
  end

  def self.down
		remove_column :uploads, :display, :string
		remove_column :uploads, :direct, :string
  end
end
