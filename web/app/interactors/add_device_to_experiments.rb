class AddDeviceToExperiments
  include Interactor::Organizer

  organize RegisterDeviceToken,
           ChooseOptionsForDistribution,
           DistributeOptionsForDeviceToken
end
