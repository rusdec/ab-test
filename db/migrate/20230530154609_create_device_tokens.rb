class CreateDeviceTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :device_tokens do |t|
      t.string :token, index: { unique: true }

      t.timestamps
    end
  end
end
