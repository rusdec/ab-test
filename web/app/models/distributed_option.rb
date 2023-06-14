class DistributedOption < Sequel::Model
  plugin :association_dependencies
  plugin :validation_helpers

  many_to_one :device_token
  many_to_one :experiment

  def validate
    super

    validates_presence :value
    validates_min_length 1, :value
    validates_max_length 100, :value
  end
end
