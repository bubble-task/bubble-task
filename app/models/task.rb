class Task < ActiveRecord::Base
  has_one :task_description
  has_many :taggings
  has_many :tags, through: :taggings

  def self.by_author(author)
    where(author_id: author.id)
  end

  def write_description(description)
    self.build_task_description(content: description)
  end

  def description
    task_description.content
  end

  def tagging(tag_contents)
    tag_contents.each do |tag_content|
      self.tags.build(content: tag_content)
    end
  end

  def tag_contents
    tags.map(&:content)
  end
end
