require 'vcr/cassette/serializers/xsyck'
require 'vcr/errors/unhandled_xml_request_error'
require 'vcr/request_handler'
require 'vcr/xml_request_handler'
require 'vcr/xpath_matcher'
require 'vcr/header_matcher'
require 'vcr/not_xpath_matcher'

module XsyckSerializer
  def new(*args, &blk)
    super(*args, &blk).extend(InstanceMethods)
  end

  module InstanceMethods
    def [](name)
      @serializers.fetch(name) do
        return @serializers[name] = VCR::Cassette::Serializers::Xsyck if name == :xsyck
      end
      super
    end
  end
end

module ExtendedMatcherRegistry
  def new(*args, &blk)
    super(*args, &blk).extend(InstanceMethods)
  end

  module InstanceMethods
    def [](matcher)
      @registry.fetch(matcher) do
        marker, xpath = matcher.to_s.split(/^xpath:/)
        return VCR::XpathMatcher.new(xpath) if xpath

        marker, notxpath = matcher.to_s.split(/^notxpath:/)
        return VCR::NotXpathMatcher.new(notxpath) if notxpath

        marker, keys = matcher.to_s.split(/^headers:\/\//)
        return VCR::HeaderMatcher.new(keys.split(',')) if keys.split(',').present?

        super
      end
    end
  end
end

module ExtendedConfiguration
  extend ActiveSupport::Concern
  included do
    attr_writer :locale
  end

  def locale
    @locale ||= :en
  end
end

VCR::Cassette::Serializers.send :extend, XsyckSerializer
VCR::RequestHandler.send :extend, XmlRequestHandler
VCR::RequestMatcherRegistry.send :extend, ExtendedMatcherRegistry
VCR::Configuration.send :include, ExtendedConfiguration
VCR::RequestMatcherRegistry.const_set :DEFAULT_MATCHERS, [:"headers://^Accept-Encoding", :"xpath://Body"]
I18n.load_path.unshift(*Dir[File.expand_path('../vcr/locales/*.yml', __FILE__)])
