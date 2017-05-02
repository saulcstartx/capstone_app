class CreateThingTags < ActiveRecord::Migration
  def change
    create_table :thing_tags do |t|
      t.text :name, {null: false}

      t.timestamps null: false
    end

    add_reference :things, :thing_tag, index: true
    add_foreign_key :things, :thing_tags
  end
end
