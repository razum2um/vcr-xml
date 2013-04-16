module VCR
  module Errors
    class UnhandledXmlRequestError < UnhandledHTTPRequestError

      autoload :Matchers, 'vcr/errors/unhandled_xml_request_error/matchers'
      autoload :Headers, 'vcr/errors/unhandled_xml_request_error/headers'
      autoload :Bodies, 'vcr/errors/unhandled_xml_request_error/bodies'
      autoload :Diffs, 'vcr/errors/unhandled_xml_request_error/diffs'
      autoload :Suggestions, 'vcr/errors/unhandled_xml_request_error/suggestions'

      include Matchers
      include Headers
      include Bodies
      include Diffs
      include Suggestions

      private

      def construct_message
        header = "\n" + "=" * 80 + "\n"
        body = [
         header_diff,
         body_matchers,
         body_diff,
         formatted_suggestions,
        ].join("\n\n")
        footer = "\n" + "=" * 80 + "\n"

        header + body + footer
      end

      def cassette_description
        if cassette = VCR.current_cassette
          ["VCR is currently using the following cassette:",
           "  - #{cassette.file}",
           "  - :record => #{cassette.record_mode.inspect}",
           "  - :match_requests_on => #{cassette.match_requests_on.inspect}\n",
           "Under the current configuration VCR can not find a suitable HTTP interaction",
           "to replay and is prevented from recording new requests. There are a few ways",
           "you can deal with this:\n"].join("\n")
        else
          ["There is currently no cassette in use. There are a few ways",
           "you can configure VCR to handle this request:\n"].join("\n")
        end
      end

      def expected_request
        @expected_request ||= VCR.http_interactions.interactions.first.try(:request)
      end

      def nokogirify(smth)
        if smth.is_a? String
          Nokogiri::XML(smth).tap { |x| x.remove_namespaces! }
        elsif smth.respond_to? :body
          Nokogiri::XML(smth.body).tap { |x| x.remove_namespaces! }
        else
          smth
        end
      end
    end
  end
end
