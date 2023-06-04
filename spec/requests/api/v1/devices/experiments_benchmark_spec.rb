require 'rails_helper'

RSpec.describe 'Api::V1::Experiments', type: :request do
  describe 'GET api/v1/devices/experiments' do
    scenario 'returns server response less than 100ms', slow_benchmark: true do
      slow_benchmark_warning('GET api/v1/devices/experiments')

      max_ms = 100
      experiments_count = 1200
      requests_count = 600

      create_list(:experiment, experiments_count)

      requests_count.times do |n|
        started_at = Time.now
        get api_v1_devices_experiments_url, headers: { 'Device-Token' => "token-#{n}" }
        response_ms = (Time.now - started_at) * 1000

        expect(response_ms).to be <= max_ms
      end
    end
  end
end
