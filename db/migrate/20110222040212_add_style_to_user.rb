class AddStyleToUser < ActiveRecord::Migration
  def self.up
		add_column :users, :background, :text, :default => ''
		add_column :users, :divs, :text, :default => ''
		add_column :users, :fonts, :text, :default => ''
  end

  def self.down
		remove_column :users, :background
		remove_column :users, :divs
		remove_column :users, :fonts
  end
end
