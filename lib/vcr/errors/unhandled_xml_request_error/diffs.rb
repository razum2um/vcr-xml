require 'diffy'

module VCR::Errors::UnhandledXmlRequestError::Diffs
  def header_diff
    return if !matched_by_headers? || header_diff_keys.empty?
    @header_diff ||= begin
      Hirb::Helpers::AutoTable.render header_diff_keys, fields: [:key, :expected, :got]
    end
  end

  def body_diff
    return if !matched_by_body? && !matched_by_xpath?
    if expected_request
      diff expected_body, received_body
    else
      diff '', format(request)
    end
  end

  def diff(xml1, xml2)
    ::Diffy::Diff.new(xml1, xml2, context: 2).to_s(:color)
  end

  def format(nodes)
    nokogirify(nodes).tap do |xml|
      xml.xpath('//text()').each do |node|
        if node.content=~/\S/
          node.content = node.content.strip
        else
          node.remove
        end
      end
    end.to_xml
  end

  def filtred_xpaths(request)
    xpath_matchers.reduce(nokogirify request) do |memo, matcher|
      matcher.extract_xpath(memo)
    end
  end
end
