module VCR
  module Errors
    class UnhandledXmlRequestError < UnhandledHTTPRequestError

      private

      def construct_message
        header = "\n" + "=" * 80
        body = [
         header_diff,
         body_matchers,
         body_diff,
        ].join("\n\n")
        footer = "\n" + "=" * 80 + "\n"

        header + body + footer
      end

      def expected_body
        @expected_body ||= format(filtred_xpaths(expected_request.body))
      end

      def received_body
        @received_body ||= format(filtred_xpaths(request.body))
      end

      def format(nodes)
        nodes.xpath('//text()').each do |node|
          if node.content=~/\S/
            node.content = node.content.strip
          else
            node.remove
          end
        end
        nodes.to_xml
      end

      def body_diff
        return if !matched_by_body? && !matched_by_xpath?
        @body_diff ||= Diffy::Diff.new(expected_body, received_body, context: 2).to_s(:color)
      end

      def matched_by_body?
        VCR.http_interactions.request_matchers.include?(:body)
      end

      def matched_by_xpath?
        VCR.http_interactions.request_matchers.any? { |m| /xpath:/.match m }
      end

      def matched_by_headers?
        VCR.http_interactions.request_matchers.include?(:headers)
      end

      def header_diff
        return if !matched_by_headers? || header_diff_keys.empty?
        @header_diff ||= begin
          Hirb::Helpers::AutoTable.render header_diff_keys, fields: [:key, :expected, :got]
        end
      end

      def header_diff_keys
        got = request.headers
        expected = expected_request.headers

        expected.diff(got).map do |k,v|
          {key: k, expected: "#{expected[k]}:<#{expected[k].class}>", got: "#{got[k]}:<#{got[k].class}>"}
        end
      end

      def expected_request
        @expected_request ||= VCR.http_interactions.interactions.first.request
      end

      def filtred_xpaths(request)
        filtred_request = request
        #filtred_request.remove_namespaces!
        #binding.pry
        xpath_matchers.reduce(filtred_request) do |memo, matcher|
          matcher.extract_xpath(memo)
        end
      end

      def body_matchers
        xpath_matchers.map do |m|
          "#{m.human_type}: #{m.xpath}"
        end.join('\n')
      end

      def xpath_matchers
        @xpath_matchers ||= VCR.http_interactions.request_matchers.map do |m|
          matcher = VCR.request_matchers[m]
          if matcher.is_a?(VCR::XpathMatcher) || matcher.is_a?(NotXpathMatcher)
            matcher
          else
            nil
          end
        end.compact
      end
    end
  end
end
