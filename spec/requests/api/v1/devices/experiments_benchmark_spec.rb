require 'rails_helper'
require 'benchmark'

RSpec.describe 'Api::V1::Experiments', type: :request do
  describe 'GET /api/v1/devices/experiments' do
    scenario 'returns server response less than 100ms', slow_benchmark: true do
      slow_benchmark_warning('GET api/v1/devices/experiments')

      requests_count = 600
      max_response_ms = 100

      experiments_count = 500

      create_list(:experiment, experiments_count/2)
      create_list(:experiment, experiments_count/2, :uniform)

      ValueDistributor::UniformStrategy.instance.refresh_cache

      response_ms = []
      requests_count.times do |n|
        headers = { 'Device-Token' => "token-#{n}" }
        response_ms << Benchmark.realtime do
          get api_v1_devices_experiments_url, headers: headers
        end
      end

      response_ms.map! { _1 * 1000 } # sec to ms
      expect(response_ms).to all( be <= max_response_ms )
    end
  end
end
