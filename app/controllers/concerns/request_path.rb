class RequestPath
  attr_reader :origin, :path

  def initialize(origin)
    @origin = origin
    parse_as_uri(origin)
  end

  def match?(other)
    if other.has_query?
      self.path == other.path
    else
      self.origin == other.origin
    end
  end

  def has_query?
    !@query.nil?
  end

  private

    def parse_as_uri(origin)
      as_uri = URI(origin)
      @path = as_uri.path
      @query = as_uri.query
    end
end
