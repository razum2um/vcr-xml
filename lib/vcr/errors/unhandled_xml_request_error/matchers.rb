module VCR::Errors::UnhandledXmlRequestError::Matchers
  def body_matchers
    xpath_matchers.map do |m|
      "#{m.human_type}: #{m.xpath}"
    end.join('\n')
  end

  def xpath_matchers
    @xpath_matchers ||= VCR.http_interactions.request_matchers.map do |m|
      matcher = VCR.request_matchers[m]
      if matcher.is_a?(VCR::XpathMatcher) || matcher.is_a?(VCR::NotXpathMatcher)
        matcher
      else
        nil
      end
    end.compact
  end

  def matched_by_body?
    matchers.empty? || matchers.include?(:body)
  end

  def matched_by_xpath?
    matchers.empty? || matchers.any? { |m| /xpath:/.match m }
  end

  def matched_by_headers?
    matchers.empty? || matchers.include?(:headers)
  end

  def matchers
    @matchers ||= VCR.http_interactions.request_matchers - [:method, :uri] # always POST to endpoint
  end
end
