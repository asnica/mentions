class Webhooks::From::Github < Webhooks::From::Base
  PATTERNS = %w(comment pull_request issue)
  ACCEPT_ACTIONS = %w(created opened assigned review_requested)

  def from
    "github"
  end

  def comment
    assigned? ? 'assigned' : search_content('body')
    case
    when assigned?
      'assigned'
    when review_requested?
      'review requested'
    else
      search_content('body')
    end
  end

  def url
    search_content('html_url')
  end

  def mentions
    case
    when assigned?
      [@payload.dig('assignee', 'login')].compact
    when review_requested?
      [@payload.dig('requested_reviewer', 'login')].compact
    else
      super
    end
  end

  def assigned?
    @payload.dig('action') == 'assigned'
  end

  def review_requested?
    @payload.dig('action') == 'review_requested'
  end

  def additional_message
    title ? "*#{title}* #{base_message}" : base_message
  end

  def accept?
    ACCEPT_ACTIONS.include?(@payload['action'])
  end

  private

  def title
    search_content('title')
  end

  def base_message
    case
    when assigned?
      "you've been assigned"
    when review_requested?
      "you've been review requested"
    else
      "you've been mentioned"
    end
  end
end
