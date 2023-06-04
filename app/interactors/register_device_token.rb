class RegisterDeviceToken
  include Interactor

  def call
    device_token = DeviceToken.find_or_initialize_by(token: context.token)

    device_token.save! if device_token.new_record?

    context.device_token = device_token
  end
end
