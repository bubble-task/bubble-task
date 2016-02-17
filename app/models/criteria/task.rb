module Criteria
  class Task
    class << self

      def create(searcher_id, options)
        completed_task = Criteria::CompletedTask.create(searcher_id, options)
        uncompleted_task = Criteria::UncompletedTask.create(searcher_id, options)

        c = case options[:completion_state]
            when 'completed'
              completed_task
            when 'uncompleted'
              uncompleted_task
            else
              [completed_task, uncompleted_task]
            end
        new(*c)
      end
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
