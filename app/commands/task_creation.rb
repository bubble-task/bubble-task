class TaskCreation
  include ActiveModel::Model

  attr_accessor :title, :description, :tag_words

  validates :title,
            presence: true,
            length: { maximum: 40 }

  validates :description,
            length: { maximum: 255 }

  validates :tag_words, tag_words: true

  def self.tags_from(tag_words)
    return [] unless tag_words
    tag_words.split(/\s+/)
  end

  def run(user)
    return nil unless valid?
    user
      .create_task(title, description, tags)
      .tap(&:save)
  end

  def tags
    self.class.tags_from(tag_words)
  end
end
