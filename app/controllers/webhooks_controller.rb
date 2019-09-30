class WebhooksController < ApplicationController
  before_action :set_webhook

  def create
    Rails.logger.info "--- in WebhooksController"
    Rails.logger.info "request.body.read:"
    Rails.logger.info request.body.read
    Rails.logger.info "request.raw_post:"
    Rails.logger.info request.raw_post
    Rails.logger.info "params:"
    Rails.logger.info params
    @webhook.run(payload: params.permit!.to_json)
    head :no_content
  end

  def show
    head :ok
  end

  private

  def set_webhook
    @webhook = Webhook.new_by_token(params[:token]) || Webhook.find_by!(token: params[:token])
  end
end
