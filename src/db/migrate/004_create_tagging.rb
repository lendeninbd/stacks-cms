class CreateTagging < ActiveRecord::Migration
  
  def self.up
    create_table :tags do |t|
      t.column :name, :string
    end
    
    create_table :documents_tags, :id => false do |t|
      t.column :document_id, :integer
      t.column :tag_id, :integer
    end
    
  end

  def self.down
    drop_table :documents_tags
    drop_table :tags
  end
  
end
