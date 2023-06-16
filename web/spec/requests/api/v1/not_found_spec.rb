require 'rails_helper'

RSpec.describe 'Api::V1::BaseController', type: :request do
  context 'when any api url not found' do
    scenario 'returns 404 error' do
      get '/api/v1/devices/experiments1'
      json = JSON.parse(response.body)

      expect(response.status).to eq(404)
      expect(json).to eq({ 'error' => 'not found' })
    end

    scenario 'returns 404 error' do
      post '/api/v1/devices/experiments'
      json = JSON.parse(response.body)

      expect(response.status).to eq(404)
      expect(json).to eq({ 'error' => 'not found' })
    end

    scenario 'returns 404 error' do
      put '/api/v1/devices/experiments'
      json = JSON.parse(response.body)

      expect(response.status).to eq(404)
      expect(json).to eq({ 'error' => 'not found' })
    end

    scenario 'returns 404 error' do
      patch '/api/v1/devices/experiments'
      json = JSON.parse(response.body)

      expect(response.status).to eq(404)
      expect(json).to eq({ 'error' => 'not found' })
    end
  end
end
