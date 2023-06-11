require 'rails_helper'

RSpec.describe 'Api::V1::Experiments', type: :request, redis: true do
  describe 'GET /api/v1/devices/experiments' do
    scenario 'registers unregistered device token' do
      token = "unregistered-token-#{rand(1..100)}"

      expect {
        get api_v1_devices_experiments_url, headers: { 'Device-Token' => token }
      }.to change(DeviceToken, :count).by(1)

      expect(DeviceToken.last.token).to eq(token)
    end

    scenario 'creates device experimet values for unregistered device token' do
      token = "unregistered-token-#{rand(1..100)}"

      experiments = create_list(:experiment, rand(2..10))

      expect {
        get api_v1_devices_experiments_url, headers: { 'Device-Token' => token }
      }.to change(DistributedOption, :count).by(experiments.count)
    end

    scenario 'does not create device experiment values twice for device token' do
      token = "unregistered-token-#{rand(1..100)}"

      experiments = create_list(:experiment, rand(2..10))

      get api_v1_devices_experiments_url, headers: { 'Device-Token' => token }

      expect {
        rand(2..5).times do
          get api_v1_devices_experiments_url, headers: { 'Device-Token' => token }
        end
      }.to_not change(DistributedOption, :count)
    end

    scenario 'does not create device token experiment for experiments created after token was registered' do
      token = "unregistered-token-#{rand(1..100)}"

      experiments = create_list(:experiment, rand(2..10))

      get api_v1_devices_experiments_url, headers: { 'Device-Token' => token }

      latest_experiments = create_list(:experiment, rand(2..10))

      expect {
        get api_v1_devices_experiments_url, headers: { 'Device-Token' => token }
      }.to_not change(DistributedOption, :count)
    end

    scenario 'returns device experiment values of device token' do
      token = "unregistered-token-#{rand(1..100)}"

      experiments = [
        create(:experiment, key: 'exp-1', options: { red: 100 }),
        create(:experiment, key: 'exp-2', options: { green: 100 }),
        create(:experiment, key: 'exp-3', options: { blue: 100 })
      ]

      get api_v1_devices_experiments_url, headers: { 'Device-Token' => token }

      json = JSON.parse(response.body)

      expect(json).to eq({
        'exp-1' => 'red',
        'exp-2' => 'green',
        'exp-3' => 'blue'
      })
    end

    scenario 'returns bad request error when device token not given' do
      get api_v1_devices_experiments_url

      json = JSON.parse(response.body)

      expect(response.status).to eq(400)
      expect(json).to eq({ 'error' => 'Empty token' })
    end
  end
end
