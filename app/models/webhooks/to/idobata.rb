class Webhooks::To::Idobata
  def initialize(message:)
    @text = message
    # TODO: support multiple hook
    @webhook_uri = ENV.fetch('IDOBATA_WEBHOOK_URL')
  end

  def post
    HttpPostJob.perform_later(@webhook_uri, { source: @text })
  end
end
