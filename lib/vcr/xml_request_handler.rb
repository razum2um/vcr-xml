module XmlRequestHandler
  def new(*args, &blk)
    super(*args, &blk).extend(InstanceMethods)
  end

  module InstanceMethods
    def on_unhandled_request
      raise VCR::Errors::UnhandledXmlRequestError.new(vcr_request)
    end
  end
end
