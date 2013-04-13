require 'vcr/cassette/serializers/xsyck'

module XsyckSerializer
  def new(*args, &blk)
    super(*args, &blk).extend(InstanceMethods)
  end

  module InstanceMethods
    def [](name)
      @serializers.fetch(name) do
        return @serializers[name] = VCR::Cassette::Serializers::Xsyck if name == :xsyck
      end
      super
    end
  end
end

VCR::Cassette::Serializers.send :extend, XsyckSerializer
