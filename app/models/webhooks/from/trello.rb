class Webhooks::From::Trello < Webhooks::From::Base
  PATTERNS = %w()

  def from
    "trello"
  end

  def comment
    comment_text = []
    comment_text << "【#{@payload.dig('event', 'data', 'card', 'name')}】"
    comment_text << ""
    comment_text << @payload.dig('event', 'data', 'text')
    comment_text.join("\n")
  end

  def url
    "https://trello.com/c/#{@payload.dig('event', 'data', 'card', 'shortLink')}#comment-#{@payload.dig('event', 'id')}"
  end

  def additional_message
    "*トレロにコメントされました。*"
  end

  def accept?
    Rails.logger.info "in Webhooks::From::Trello ---"
    Rails.logger.info "@payload:"
    Rails.logger.info @payload
    Rails.logger.info "@payload.dig('event', 'type'):"
    Rails.logger.info @payload.dig('event', 'type')
    @payload.dig('event', 'type') == 'commentCard'
  end
end
