class CreateIndexes < ActiveRecord::Migration
  def self.up
    add_index :documents, :title
  end

  def self.down
  end
end
