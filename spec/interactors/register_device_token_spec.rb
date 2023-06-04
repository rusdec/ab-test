require 'rails_helper'

RSpec.describe RegisterDeviceToken do
  describe '.call' do
    context 'when device token is not registered' do
      let(:context) { described_class.call(token: token) }
      let(:token) { build(:device_token).token }

      it 'creates device token' do
        expect { context }.to change(DeviceToken, :count).by(1)
      end

      it 'context haves device token' do
        expect(context.device_token.token).to eq(token)
      end

      it 'should be success' do
        expect(context).to be_success
      end

      context "and token invalid" do
        it 'raises error' do
          invalid_token = build(:device_token, :invalid).token

          expect { described_class.call(token: invalid_token) }
            .to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    context 'when device token is registered' do
      let(:context) { described_class.call(token: device_token.token) }
      let!(:device_token) { create(:device_token) }

      it 'does not create device token' do
        expect { context }.to_not change(DeviceToken, :count)
      end

      it 'context haves device token' do
        expect(context.device_token).to eq(device_token)
      end

      it 'should be success' do
        expect(context).to be_success
      end
    end
  end
end
