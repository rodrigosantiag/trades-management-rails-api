# frozen_string_literal: true
# ActiveModelSerializers.config.adapter = :json_api
#
# ActionDispatch::Request.parameter_parsers[:json] = -> (raw_post) {
#   data = ActiveSupport::JSON.decode(raw_post)
#   data = {:_json => data} unless data.is_a?(Hash)
#   data.deep_transform_keys!(&:underscore)
# }
