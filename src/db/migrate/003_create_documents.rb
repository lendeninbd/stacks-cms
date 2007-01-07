class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.column :type,           :string
      t.column :title,          :string
      t.column :raw_text,       :text
      t.column :formatted_text, :text
      t.column :created_on,     :timestamp
      t.column :edited_on,      :timestamp
    end
  end

  def self.down
    drop_table :documents
  end
end
