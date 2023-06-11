class CreateExperiments < ActiveRecord::Migration[7.0]
  def change
    create_table :experiments do |t|
      t.string :title, null: false
      t.string :key, null: false, limit: 100
      t.json :options, null: false
      t.json :probability_line, null: false
      t.integer :distribution_type, null: false

      t.timestamps
    end

    add_index :experiments, :created_at
    add_index :experiments, :distribution_type
  end
end
