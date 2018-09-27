require 'rest-client'

class WelcomeController < ApplicationController
  def index
    @title = 'CCS Example App2'
    @localEnv = ENV

    appConfig = AppConfig.new()
    @featureEG1 = appConfig.isFeatureEnabled('EG1')
    api_url = appConfig.getApiURL('api2') << '/systeminfo?detail=all'

    begin
      response = RestClient::Request.execute(method: :get, url: api_url, timeout: 0.1)
      @apiResponse = JSON.parse(response)
    rescue
      @apiCallOK = false
    else
      @apiCallOK = true
    end
  end
end
