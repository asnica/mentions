class Webhooks::To::Slack
  def initialize(message:)
    @channel = ENV.fetch('SLACK_CHANNEL')
    @text = message
    @webhook_uri = ENV.fetch('SLACK_WEBHOOK_URL')
  end

  def post
    HttpPostJob.perform_now(@webhook_uri, { payload: {text: @text, link_names: 1, channel: @channel}.to_json })
  end
end
