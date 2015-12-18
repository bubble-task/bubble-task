module Criteria
  class Achievement
    Author = Struct.new(:id) do

      def satisfy(relation)
        relation.where(author_id: id)
      end
    end
  end
end
