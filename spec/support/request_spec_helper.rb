# frozen_string_literal: true

# Parser for JSON response
module RequestSpecHelper
  def json_body
    @json_body ||= JSON.parse(response.body, symbolize_names: true)
  end
end
