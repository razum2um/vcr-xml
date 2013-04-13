require "vcr/xml/version"

module YxmlSerializer
  def self.included(base)
    autoload :Yxml,  'vcr/cassette/serializers/yxml'
  end

  def [](name)
    @serializers.fetch(name) do |_|
      @serializers[name] = case name
        when :yaml  then YAML
        when :syck  then Syck
        when :psych then Psych
        when :json  then JSON
        when :yxml  then Yxml
        else raise ArgumentError.new("The requested VCR cassette serializer (#{name.inspect}) is not registered.")
      end
    end
  end
end

VCR::Cassette::Serializers.send :include, YxmlSerializer
