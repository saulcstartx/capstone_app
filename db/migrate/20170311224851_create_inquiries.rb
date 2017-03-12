class CreateInquiries < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.string :title, { null: false }
      t.text :question, { null: false }
      t.integer :customer_id, { null: false }

      t.timestamps null: false
    end

    add_index :inquiries, :customer_id
  end
end
