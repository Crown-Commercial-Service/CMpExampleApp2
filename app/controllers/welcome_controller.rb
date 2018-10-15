require 'rest-client'

class WelcomeController < ApplicationController
  def index
    @title = 'CCS Example App2'
    @localEnv = ENV
    apiNames = ['api1', 'api2']

    appConfig = AppConfig.new()
    @featureEG1 = appConfig.isFeatureEnabled('EG1')
    @apiResponses = []
    apiNames.each do |name|
      base_url = appConfig.getApiURL(name)
      api_url = "#{base_url}/systeminfo?detail=all"
      data = Hash.new
      @apiResponses.push(data)
      data['name'] = name.to_str
      data['base_url'] = base_url.to_str
      begin
        response = RestClient::Request.execute(method: :get, url: api_url, timeout: 0.1)
        data['response'] = JSON.parse(response)
      rescue
        data['apiCallOK'] = false
      else
        data['apiCallOK'] = true
      end
    end
  end
end
