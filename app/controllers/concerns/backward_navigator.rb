class BackwardNavigator
  STORE_KEY = 'backward_path'.freeze

  def initialize(storage, backable_paths = [RequestPath.new('/')])
    @storage = storage
    @storage[STORE_KEY] = backable_paths.first
    @backable_paths = backable_paths
  end

  def update_backward_path(path)
    if backable_path?(path)
      @storage[STORE_KEY] = path
    end
  end

  def backward_path
    @storage[STORE_KEY]
  end

  private

    def backable_path?(candidate)
      @backable_paths.detect { |p| p.match?(candidate) }
    end
end
