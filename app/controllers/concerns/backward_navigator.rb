class BackwardNavigator
  class << self

    def detect_backward_path(current_path, referer_path)
      return current_path unless referer_path
      return referer_path if backable_path?(referer_path)
      current_path
    end

    def backable_path?(path_as_string)
      candidate = RequestPath.new(path_as_string)
      @backable_paths.one? { |p| p.match?(candidate) }
    end

    def register_backable_paths(paths)
      @backable_paths = paths.map { |p| RequestPath.new(p) }
    end
  end

  STORE_KEY = 'backward_path'.freeze

  def initialize(storage, backable_paths = ['/'])
    @storage = storage
    @backable_paths = backable_paths
    initialize_storage
  end

  def update_backward_path(path)
    @storage[STORE_KEY] = path
  end

  def backward_path
    @storage[STORE_KEY]
  end

  private

    def initialize_storage
      unless @storage.has_key?(STORE_KEY)
        @storage[STORE_KEY] = @backable_paths.first
      end
    end
end
