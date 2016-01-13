BackwardNavigator = Struct.new(:backward_path) do
  class << self

    def register_backable_paths(paths)
      @backward_paths = paths
    end

    def backward_paths
      @backward_paths ||= ['/']
    end

    def registered_backable_path?(path)
      backward_paths.include?(path)
    end

    def default_backward_path
      backward_paths.first
    end

    def update_backable_path(path)
      backable_path = if registered_backable_path?(path)
                        path
                      else
                        default_backward_path
                      end
      new(backable_path)
    end
  end
end
