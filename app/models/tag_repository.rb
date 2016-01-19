module TagRepository
  module_function

  def index(term = nil)
    Tagging.all.order(:tag).select(:tag).distinct.pluck(:tag) unless term
    Tagging.where('tag LIKE ?', "#{term}%" ).order(:tag).select(:tag).distinct.pluck(:tag)
  end
end
