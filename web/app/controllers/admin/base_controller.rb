module Admin
  class BaseController < ApplicationController
    layout 'admin'

    def not_found
      render Admin::NotFoundComponent.new, status: :not_found
    end
  end
end
