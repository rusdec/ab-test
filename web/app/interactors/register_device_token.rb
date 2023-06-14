class RegisterDeviceToken
  include Interactor

  def call
    device_token = DeviceToken.find_or_create(token: context.token)

    context.device_token = device_token
  end
end
