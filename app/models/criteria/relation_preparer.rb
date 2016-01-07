module Criteria
  class RelationPreparer

    def initialize(relation)
      @relation = relation
      @use_joins = false
      @associations = %i(completed_task assignments taggings)
    end

    def use_joins
      @use_joins = true
      self
    end

    def relation
      return @relation.joins(*@associations).preload(*@associations) if @use_joins
      @relation.includes(*@associations)
    end
  end
end
