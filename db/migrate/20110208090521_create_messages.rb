class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.text :content
      t.integer :recipient
      t.integer :sender
      t.string :subject
			t.boolean :read_state, :default => false
      t.timestamps
    end
		add_index :messages, :recipient
		add_index :messages, :sender
  end

  def self.down
    drop_table :messages
  end
end
