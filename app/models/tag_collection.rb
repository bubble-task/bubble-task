class TagCollection
  attr_reader :tags

  def self.create_from_taggings(taggings)
    new.tap do |me|
      me.add(taggings.map(&:tag))
    end
  end

  def add(tags)
    @tags = tags
  end

  def remove_all!
    @tags = []
  end

  def save(task)
    task.taggings.destroy_all
    @tags.each do |tag|
      task.taggings.build(tag: tag)
    end
  end
end
