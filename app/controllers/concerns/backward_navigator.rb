BackwardNavigator = Struct.new(:backward_path) do

  def self.update_backable_path(path)
    backable_path = if path != '/'
                      '/'
                    else
                      path
                    end
    new(backable_path)
  end
end
