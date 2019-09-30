class Webhooks::From::Bitbucket < Webhooks::From::Base
  PATTERNS = %w(comment pullrequest issue)

  def comment
    search_content('content', 'raw') || search_content('description')
  end

  def url
    search_content('links', 'html', 'href')
  end

  def from
    "bitbucket"
  end
end
