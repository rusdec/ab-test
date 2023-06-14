Sequel.migration do
  up do
    puts "Creating table 'distributed_options'"
    create_table(:distributed_options) do
      foreign_key :device_token_id, :device_tokens, null: false, on_delete: :cascade
      foreign_key :experiment_id, :experiments, null: false, on_delete: :cascade
      String :value, null: false,size: 100
    end
  end

  down do
    puts "Droping table 'distributed_options'"
    drop_table(:distributed_options)
  end
end
