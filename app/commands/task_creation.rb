class TaskCreation
  include ActiveModel::Model

  attr_accessor :title, :description, :tag_words

  validates :title,
            presence: true,
            length: { maximum: 40 }

  validates :description,
            length: { maximum: 255 }

  def run(user)
    return nil unless valid?
    user
      .create_task(title, description, tags)
      .tap(&:save)
  end

  private

    def tags
      tag_words.split(/\s+/)
    end
end
