Sequel.migration do
  change do
    create_table(:ar_internal_metadata) do
      column :key, "character varying", :null=>false
      column :value, "character varying"
      column :created_at, "timestamp(6) without time zone", :null=>false
      column :updated_at, "timestamp(6) without time zone", :null=>false
      
      primary_key [:key]
    end
    
    create_table(:schema_migrations) do
      column :version, "character varying", :null=>false
      
      primary_key [:version]
    end
  end
end
