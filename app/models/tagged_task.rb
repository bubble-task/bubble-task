class TaggedTask < SimpleDelegator
  attr_reader :tags

  def initialize(task, tags)
    super(task)
    @tags = tags
  end
end
