module VCR
  class Cassette
    class Serializers
      module Yxml
        include Syck
        extend self

        def serialize(hash)
          hash['http_interactions'].each do |i|
            pretty_xml i['request']['body']['string']
            pretty_xml i['response']['body']['string']
          end
          super(hash)
        end

        private

        def pretty_xml(string)
          string.replace Nokogiri::XML(string).to_xml
        end
      end
    end
  end
end
