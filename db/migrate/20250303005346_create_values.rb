class CreateValues < ActiveRecord::Migration[8.0]
  def change
    create_table :values do |t|
      t.integer :value
      t.references :user, null: false, foreign_key: true
      t.references :image, null: false, foreign_key: true

      t.timestamps
    end
  end
end
