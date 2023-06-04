class DeviceToken < ApplicationRecord
  has_many :device_experiment_values, dependent: :destroy
  has_many :experiments, class_name: 'Experiment', through: :device_experiment_values

  validates :token, presence: true, uniqueness: true
end
