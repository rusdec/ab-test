class DeviceToken < Sequel::Model
  plugin :association_dependencies
  plugin :many_through_many
  plugin :validation_helpers
  plugin :timestamps, update_on_create: true

  one_to_many :distributed_options
  add_association_dependencies distributed_options: :destroy

  many_to_many :experiments, join_table: :distributed_options

  def validate
    super

    validates_presence :token
    validates_unique :token
    validates_min_length 1, :token
    validates_max_length 250, :token
  end
end
