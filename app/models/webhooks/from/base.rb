class Webhooks::From::Base
  PATTERNS = %w()

  attr_reader :payload

  def initialize(payload:)
    Rails.logger.info "in Webhooks::From::Base ---"
    Rails.logger.info "JSON.parse(payload):"
    Rails.logger.info JSON.parse(payload)
    @payload = JSON.parse(payload)
  end

  def comment
    ''
  end

  def url
    ''
  end

  def mentions
    return [] unless comment
    comment.scan(/@([\S]+)/).flatten.uniq || []
  end

  def additional_message
    ""
  end

  def accept?
    true
  end

  def send_message(to:)
    messages = []
    messages << additional_message if additional_message.present?
    messages << url if url.present?
    messages << ""
    messages << "```"
    transed_comment = comment
    Rails.logger.info "comment: line #{__LINE__} in file #{__FILE__}, in method '#{__method__}'"
    Rails.logger.info comment
    return messages.join("\n") if transed_comment.blank?

    Rails.logger.info "mentions: line #{__LINE__} in file #{__FILE__}, in method '#{__method__}'"
    Rails.logger.info mentions
    mentions.map { |m|
      id_mapping ||= IdMapping.new(ENV.fetch('MENTIONS_MAPPING_FILE_PATH'))
      to_user_name = id_mapping.find(user_name: m, from: from, to: to)
      Rails.logger.info "m: line #{__LINE__} in file #{__FILE__}, in method '#{__method__}'"
      Rails.logger.info m
      transed_comment = transed_comment.gsub("@#{m}", to_user_name)
    }.compact
    messages << transed_comment

    messages << "```"
    messages.join("\n")
  end

  def mentions_map(from: from, to: to)
    mentions.map { |m|
      id_mapping ||= IdMapping.new(ENV.fetch('MENTIONS_MAPPING_FILE_PATH'))
      id_mapping.find(user_name: m, from: from, to: to)
    }.compact
  end

  def from
    ""
  end

  private

  def search_content(*keys)
    self.class::PATTERNS.map { |pattern| @payload.dig(*[pattern, *keys]) }.compact.first
  end
end
