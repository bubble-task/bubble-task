module Criteria
  class Association

    def initialize(left_relation, join_type, right_relation)
      @left_table_name = left_relation.to_s.pluralize
      @right_table_name = right_relation.to_s.pluralize
      @join_type = join_type.to_s.upcase.tr('_', ' ')
      @foreign_key = "#{@left_table_name.singularize}_id"
    end

    def to_sql
      "#{@join_type} JOIN #{@right_table_name} ON #{@right_table_name}.#{@foreign_key} = #{@left_table_name}.id"
    end
  end
end
