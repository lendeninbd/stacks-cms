class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.column :type,           :string
      t.column :title,          :string
      t.column :markdown_text,  :text
      t.column :raw_text,       :text
      t.column :formatted_text, :text
      t.column :created_at,     :datetime
      t.column :edited_at,      :datetime
    end
  end

  def self.down
    drop_table :documents
  end
end
