module VCR::Errors::UnhandledXmlRequestError::Suggestions
  extend ActiveSupport::Concern

  def suggestion_for(k)
    k
  end

  def match_requests_on_suggestion
    :match_requests_on
  end

  def translated_suggestions
    translating do
      suggestions.map do |suggestion|
        I18n.t("vcr.suggestions.#{suggestion}")
      end
    end
  end

  def translated_cassette_description
    translating do
      if cassette = VCR.current_cassette
        I18n.t(
          "vcr.cassette",
           file: cassette.file,
           mode: cassette.record_mode.inspect,
           matchers: cassette.match_requests_on.inspect
        )
      else
        I18n.t("vcr.no_cassette")
      end
    end
  end

  private

  def translating
    locale = I18n.locale
    I18n.locale = VCR.configuration.locale
    ret = yield
    I18n.locale = locale
    ret
  end
end

