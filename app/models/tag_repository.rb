module TagRepository
  module_function

  def index
    Task.all.flat_map(&:tags).uniq.sort
  end
end
