module Criteria
  class RelationWrapper

    def initialize(relation)
      @relation = relation
      @use_joins = false
      @additionals = %i(completed_task assignments taggings)
    end

    def use_joins
      @use_joins = true
      self
    end

    def prepare
      return @relation.joins(*@additionals) if @use_joins
      @relation.includes(*@additionals)
    end
  end
end
