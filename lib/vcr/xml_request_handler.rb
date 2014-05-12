module XmlRequestHandler
  def new(*args, &blk)
    super(*args, &blk).extend(InstanceMethods)
  end

  module InstanceMethods
    def on_unhandled_request
      if ENV['HEADLESS'] != true && !VCR.http_interactions.is_a?(VCR::Cassette::HTTPInteractionList::NullList) && /<\?xml/.match(vcr_request.body)
        raise VCR::Errors::UnhandledXmlRequestError.new(vcr_request)
      else
        super
      end
    end
  end
end
