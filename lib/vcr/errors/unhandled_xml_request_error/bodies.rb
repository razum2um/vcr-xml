module VCR::Errors::UnhandledXmlRequestError::Bodies
  def expected_body
    @expected_body ||= format(filtred_xpaths(expected_request.body))
  end

  def received_body
    @received_body ||= format(filtred_xpaths(request.body))
  end
end
