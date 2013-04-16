module VCR
  class NotXpathMatcher < Struct.new(:xpath)
    def matches?(request, expected_request)
      node = extract_xpath(request.body)
      expected_node = extract_xpath(expected_request.body)

      EquivalentXml.equivalent? node, expected_node
    end

    def human_type
      "exclude"
    end

    def extract_xpath(xml)
      if xml.is_a? String
        xml = Nokogiri::XML(xml)
        xml.remove_namespaces!
      end
      xml.search(xpath).remove
      xml
    end
  end
end
