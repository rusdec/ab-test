class CreateDistributedOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :distributed_options, id: false do |t|
      t.references :device_token, null: false, foreign_key: true
      t.references :experiment, null: false, foreign_key: true
      t.string :value, null: false, limit: 100
    end
  end
end
