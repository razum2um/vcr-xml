module VCR::Errors::UnhandledXmlRequestError::Headers
  def received_headers
    @received_headers ||= request.headers
  end

  def expected_headers
    @expected_headers ||= expected_request.try(:headers) || {}
  end

  def header_diff_keys
    expected_headers.diff(received_headers).map do |k,v|
      {
        key: k,
        expected: "#{expected_headers[k]}:<#{expected_headers[k].class}>",
        got: "#{received_headers[k]}:<#{received_headers[k].class}>"
      }
    end
  end
end
