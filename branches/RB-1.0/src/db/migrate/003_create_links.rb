class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.column :document_id,  :integer
      t.column :title,    :string
      t.column :existing,   :boolean
    end
  end

  def self.down
    drop_table :links
  end
end
