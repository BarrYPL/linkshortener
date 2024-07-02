class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links do |t|
      t.references :user, null: false, foreign_key: true
      t.string :url
      t.string :url_short
      t.integer :visits
      t.string :category

      t.timestamps
    end
  end
end
