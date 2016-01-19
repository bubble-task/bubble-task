module TagRepository
  module_function

  def index(term = nil)
    relation = if term
                 Tagging.where('tag LIKE ?', "#{term}%" )
               else
                 Tagging.all
               end
    relation.order(:tag).select(:tag).distinct.pluck(:tag)
  end
end
