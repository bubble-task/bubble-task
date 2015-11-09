class Calculation
  include ActiveModel::Model

  attr_accessor :left, :right, :operator

  validates :left, numericality: true

  def self.operators
    [:+, :-, :*, :/]
  end

  def compute!
    if valid?
      @answer = left.to_i.send(operator, right.to_i)
    end
  end

  def describe
    "#{left} #{operator} #{right} = #{@answer}"
  end
end
