RequestPath = Struct.new(:path, :query) do

  def initialize(origin)
    super(*parse_as_uri(origin))
  end

  def match?(other)
    self.path == other.path
  end

  def has_query?
    !query.nil?
  end

  private

    def parse_as_uri(origin)
      as_uri = URI(origin)
      [as_uri.path, as_uri.query]
    end
end
