# frozen_string_literal: true

# API Version contraint
class ApiVersionConstraint
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default || req.headers['Accept'].include?("application/vnd.binaryoptionsmanagement.v#{@version}")
  end
end
