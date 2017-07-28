class CreateLayouts < ActiveRecord::Migration
  def change
    create_table :layouts do |t|
      t.integer :turn_id
      t.integer :hole_id

      t.timestamps null: false
    end
  end
end
