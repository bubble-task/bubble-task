class Task < ActiveRecord::Base
  has_one :task_description
  has_many :taggings

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
      self.taggings.build(tag: tag_content)
    end
  end

  def tags
    taggings.map(&:tag)
  end
end
