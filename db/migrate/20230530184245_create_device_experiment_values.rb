class CreateDeviceExperimentValues < ActiveRecord::Migration[7.0]
  def change
    create_table :device_experiment_values do |t|
      t.references :device_token, null: false, foreign_key: true
      t.references :experiment, null: false, foreign_key: true
      t.string :value
    end
  end
end
