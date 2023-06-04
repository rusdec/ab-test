class AddDeviceToExperiments
  include Interactor::Organizer

  organize RegisterDeviceToken,
           ChooseValuesFromExperiments,
           CreateValuesForDevice
end
