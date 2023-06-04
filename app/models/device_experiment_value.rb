class DeviceExperimentValue < ApplicationRecord
  belongs_to :device_token
  belongs_to :experiment

  validates :value, length: { maximum: 1000 }
end
