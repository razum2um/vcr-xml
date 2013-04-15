module VCR
  class XpathMatcher < Struct.new(:xpath)
    def matches?(request, expected_request)
      node = extract_xpath(request.body)
      return false if node.blank?

      expected_node = extract_xpath(expected_request.body)
      return false if expected_node.blank?

      EquivalentXml.equivalent? node, expected_node
    end

    def human_type
      "only"
    end

    def extract_xpath(xml)
      if xml.is_a? String
        xml = Nokogiri::XML(xml)
        xml.remove_namespaces!
      end
      xml.xpath(xpath)
    end
  end
end
