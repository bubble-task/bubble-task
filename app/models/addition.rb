class Addition
  include ActiveModel::Model

  attr_accessor :left, :right

  def compute!
    @answer = left.to_i + right.to_i
  end

  def describe
    "#{left} + #{right} = #{@answer}"
  end
end
