class BackwardNavigator
  STORE_KEY = 'backward_path'.freeze

  def initialize(storage, backable_paths = ['/'])
    @backable_paths = backable_paths
    @storage = storage
    @storage[STORE_KEY] = default_backward_path
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

    def backable_path?(path)
      @backable_paths.include?(path)
    end

    def default_backward_path
      @backable_paths.first
    end
end
