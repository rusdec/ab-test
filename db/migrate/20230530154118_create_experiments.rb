class CreateExperiments < ActiveRecord::Migration[7.0]
  def change
    create_table :experiments do |t|
      t.string :title, null: false
      t.text :description, null: true
      t.string :key, null: false
      t.json :options, null: false

      t.timestamps
    end

    add_index :experiments, :created_at
  end
end
