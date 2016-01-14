RequestPath = Struct.new(:origin, :path, :query) do

  def initialize(origin)
    path, query = parse_as_uri(origin)
    super(origin, path, query)
  end

  def match?(other)
    if other.has_query?
      self.path == other.path
    else
      self.origin == other.origin
    end
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
