class Calculation
  include ActiveModel::Model

  attr_accessor :left, :right, :operator

  def initialize(params = {})
    super
    self.left = left.to_i
    self.right = right.to_i
  end

  def compute!
    @answer = left.send(operator, right)
  end

  def describe
    "#{left} #{operator} #{right} = #{@answer}"
  end
end
