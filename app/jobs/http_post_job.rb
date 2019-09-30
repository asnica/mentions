class HttpPostJob < ApplicationJob
  def perform(uri, params)
    require 'net/http'
    Rails.logger.info "--- in HttpPostJob"
    Rails.logger.info "params:"
    Rails.logger.info params
    Rails.logger.info "uri:"
    Rails.logger.info uri
    Net::HTTP.post_form(URI.parse(uri), params)
  end
end
