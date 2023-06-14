Sequel.migration do
  up do
    puts "Creating table 'experiments'"
    create_table(:experiments) do
      primary_key :id
      String :title, null: false
      String :key, null: false, size: 50
      column :options, :json, null: false
      column :probability_line, :json, null: false
      Integer :distribution_type, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :created_at
      index :distribution_type
    end
  end

  down do
    puts "Droping table 'experiments'"
    drop_table(:experiments)
  end
end
