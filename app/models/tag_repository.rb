module TagRepository
  module_function

  def index
    Tagging.all.order(:tag).select(:tag).distinct.pluck(:tag)
  end
end
