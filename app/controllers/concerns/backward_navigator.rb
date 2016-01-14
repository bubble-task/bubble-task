class BackwardNavigator
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
