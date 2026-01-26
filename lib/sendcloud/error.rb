module Sendcloud
  class Error < StandardError
    attr_reader :response

    def initialize(error_detail, response:)
      super(error_detail)
      @response = response
    end
  end

  class ConflictError < Error
  end
end
