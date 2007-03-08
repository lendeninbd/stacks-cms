class CreateIndexes < ActiveRecord::Migration
  def self.up
    add_index :documents, :title
    add_index :tags, :name
    add_index :taggings, [ :tag_id, :taggable_id, :taggable_type ]
  end

  def self.down
  end
end
