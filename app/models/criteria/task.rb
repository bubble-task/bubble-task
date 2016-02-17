module Criteria
  class Task

    def self.create(searcher_id, options)
      c = case options[:completion_state]
          when 'completed'
            Criteria::CompletedTask.create(searcher_id, options)
          when 'uncompleted'
            Criteria::UncompletedTask.create(searcher_id, options)
          else
            [
              Criteria::CompletedTask.create(searcher_id, options),
              Criteria::UncompletedTask.create(searcher_id, options),
            ]
          end
      new(*c)
    end

    def initialize(*criterias)
      @criterias = criterias
    end

    def satisfy(relation)
      results =
        @criterias.each_with_object([]) do |c, r|
          r << c.satisfy(relation)
        end
      results.inject(:+).uniq
    end
  end
end
