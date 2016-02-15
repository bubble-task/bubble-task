module Criteria
  class Task

    def self.create(options)
      c = case options[:completion_state]
          when 'completed'
            Criteria::CompletedTask.create(options)
          when 'uncompleted'
            Criteria::UncompletedTask.create(options)
          else
            [
              Criteria::CompletedTask.create(options),
              Criteria::UncompletedTask.create(options),
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
