module VCR
  class Cassette
    class Serializers
      module Xsyck
        extend EncodingErrorHandling
        extend self

        ENCODING_ERRORS = [ArgumentError]

        def file_extension
          "yml"
        end

        def deserialize(string)
          handle_encoding_errors do
            ::Syck.load(string)
          end
        end

        def serialize(hash)
          hash['http_interactions'].each do |i|
            pretty_xml i['request']['body']['string'] if /<\?xml/.match i['request']['body']['string']
            pretty_xml i['response']['body']['string'] if /<\?xml/.match i['response']['body']['string']
          end
          handle_encoding_errors do
            ::Syck.dump(hash)
          end
        end

        private

        def pretty_xml(string)
          string.replace Nokogiri::XML(string).to_xml.encode!('utf-8')
        end
      end
    end
  end
end
