module VCR
  class HeaderMatcher < Struct.new(:keys)
    def matches?(request, expected_request)
      requested_headers = request.headers
      expected_headers = expected_request.headers

      if only_keys.present?
        requested_headers.slice!(*only_keys)
        expected_headers.slice!(*only_keys)
      end

      if  without_keys.present?
        requested_headers.except!(*without_keys)
        expected_headers.except!(*without_keys)
      end

      requested_headers == expected_headers
    end

    def without_keys
      keys.map do |k|
        prefix, key_name = k.split(/^\^/)
        key_name if key_name.present?
      end.compact
    end

    def only_keys
      keys.map do |k|
        prefix, key_name = k.split(/^\^/)
        prefix if prefix.present?
      end.compact
    end

    def human_type
      ""
    end
  end
end
