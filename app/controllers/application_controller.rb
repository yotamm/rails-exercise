class ApplicationController < ActionController::Base

    def not_found_error
        raise ActionController::RoutingError.new('Not Found')
    end

    def permission_denied_error
        raise ActionController::RoutingError.new('Permission Denied')
    end
end
