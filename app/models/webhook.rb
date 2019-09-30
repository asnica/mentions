class Webhook < ApplicationRecord
  FROM = %w(trello github esa bitbucket)
  TO = %w(slack idobata)

  validates :from, inclusion: { in: FROM }
  validates :to, inclusion: { in: TO }
  validates :token, uniqueness: true

  before_validation :set_token, on: :create, unless: -> { token }

  class << self
    def new_by_token(token)
      if webhook_attributes = tokens_in_env.find { |w| w[:token] == token }
        Webhook.new(webhook_attributes)
      end
    end

    private

    def tokens_in_env
      FROM.map { |f| TO.map { |t| {from: f, to: t, token: token_in_env(f, t)} } }.flatten
    end

    def token_in_env(from, to)
      ENV.fetch("#{from.upcase}_TO_#{to.upcase}_TOKEN", nil)
    end
  end

  def from_class
    Webhooks::From.const_get(from.classify)
  end

  def to_class
    Webhooks::To.const_get(to.classify)
  end

  def run(payload:)
    Rails.logger.info "payload:"
    Rails.logger.info payload
    from_instance = from_class.new(payload: payload)
    Rails.logger.info "from_instance.accept?: line #{__LINE__} in file #{__FILE__}, in method '#{__method__}'"
    Rails.logger.info from_instance.accept? ? "true" : "false"
    Rails.logger.info "from_instance.class.to_s: line #{__LINE__} in file #{__FILE__}, in method '#{__method__}'"
    Rails.logger.info from_instance.class.to_s
    return unless from_instance.accept?

    Rails.logger.info "from_instance.url: line #{__LINE__} in file #{__FILE__}, in method '#{__method__}'"
    Rails.logger.info from_instance.url
    Rails.logger.info "rom_instance.send_message: line #{__LINE__} in file #{__FILE__}, in method '#{__method__}'"
    Rails.logger.info from_instance.send_message(to: to)
    to_class.new(message: from_instance.send_message(to: to)).post
  end

  private

  def set_token
    self.token = SecureRandom.uuid.gsub(/-/,'')
  end
end
