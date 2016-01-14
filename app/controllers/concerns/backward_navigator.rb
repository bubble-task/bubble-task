class BackwardNavigator
  STORE_KEY = 'backward_path'.freeze

  def initialize(storage, backable_paths = ['/'])
    @storage = storage
    @storage[STORE_KEY] = backable_paths.first
    @backable_paths_for_matching = backable_paths.sort_by(&:size).reverse
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
      if path.include?('?')
        match_with_query?(path)
      else
        @backable_paths_for_matching.include?(path)
      end
    end

    def match_with_query?(path)
      @backable_paths_for_matching.detect do |backable_path|
        path =~ /#{backable_path}/
      end
    end
end
