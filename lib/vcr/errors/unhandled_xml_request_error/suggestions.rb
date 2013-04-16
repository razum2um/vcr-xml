module VCR::Errors::UnhandledXmlRequestError::Suggestions
  extend ActiveSupport::Concern

  def suggestion_for(k)
    k
  end

  def match_requests_on_suggestion
    :match_requests_on
  end

  def formatted_suggestions
    locale = I18n.locale
    I18n.locale = VCR.configuration.locale
    ret = suggestions.map do |suggestion|
      I18n.t("vcr.suggestions.#{suggestion}")
    end
    I18n.locale = locale
    ret
  end
end

