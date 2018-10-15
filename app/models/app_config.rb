=begin
 This simple class represents the Application configuration.
 
 The following environment variables are supported:
 
 CCS_API_BASE_URL
      Base URL for API access with no protocol or trailing /
 CCS_API_PROTOCOL
      API protocol, 'http' or 'https'
 CCS_APP_BASE_URL
      Base URL for APP access with no protocol or trailing /
 CCS_APP_PROTOCOL
      APP protocol, 'http' or 'https'
 
 Features swtiches can also be specified with the prefx CCS_FEATURE_
 The value must be 'on', 'off', 'enabled', 'disabled', 'true' or 'false', 'yes' or 'no'.
 
      For example: CCS_FEATURE_EG1=on
=end
require 'json'

class AppConfig

    # Create new application config
    def initialize()

        @ENV_API_BASE_URL = "CCS_API_BASE_URL"
        @ENV_API_PROTOCOL = "CCS_API_PROTOCOL"
        @ENV_APP_BASE_URL = "CCS_APP_BASE_URL"
        @ENV_APP_PROTOCOL = "CCS_APP_PROTOCOL"
        @ENV_FEATURE_PREFIX = "CCS_FEATURE_"
    
        # Set defaults
        @appProtocol = "http"
        @appBaseURL = "roweitdev.co.uk"
        @apiProtocol = "http"
        @apiBaseURL = "ccsdev-internal.org"

        # Dictionary of available features
        @featureInfo = {}

        # Read what we can from the environment
        ENV.each do |k, v| 
            evTest = k.upcase.strip
            if evTest == @ENV_API_BASE_URL
                @apiBaseURL = v.strip
            elsif evTest == @ENV_API_PROTOCOL
                @apiProtocol = v.strip
            elsif evTest == @ENV_APP_BASE_URL
                @appBaseURL = v.strip
            elsif evTest == @ENV_APP_PROTOCOL
                @appProtocol = v.strip
            elsif evTest.start_with?(@ENV_FEATURE_PREFIX)
                if ENV['DEBUG']
                    logger.debug( evTest );
                end

                # Extract feature name and determine if its enabled or not
                featureName = evTest[@ENV_FEATURE_PREFIX.length, evTest.length - @ENV_FEATURE_PREFIX.length]
                enabled = false
                val = v.upcase.strip
                if (val == "ON") || (val == "TRUE") || (val == "YES") || (val == "ENABLED")
                    enabled = true;
                end
                @featureInfo[featureName] = enabled
            end
        end
        
        if ENV['DEBUG']
            # Summary of settings
            logger.debug( "CCS_API_BASE_URL = [#{@apiBaseURL}]" )
            logger.debug( "CCS_API_PROTOCOL = [#{@apiProtocol}]" )
            logger.debug( "CCS_APP_BASE_URL = [#{@appBaseURL}]" )
            logger.debug( "CCS_APP_PROTOCOL = [#{@appProtocol}]" )
            logger.debug( "FEATURES = #{@featureInfo.to_json}" )
        end
    
    end

    # Return the URL to access a specific APi
    def getApiURL( apiName )
        return "#{@apiProtocol}://#{apiName}.#{@apiBaseURL}"
    end
    
    # Returns true if a particular feature is enabled
    def isFeatureEnabled( featureName ) 
        return @featureInfo[featureName.upcase.strip] ? true : false
    end
end
