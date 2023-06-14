Sequel.migration do
  up do
    puts "Creating table 'device_tokens'"
    create_table(:device_tokens) do
      primary_key :id
      String :token, unique: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end

  down do
    puts "Droping table 'device_tokens'"
    drop_table(:device_tokens)
  end
end
