module Kincaid
  class Edge
    attr_reader :a, :b

    def self.[](a, b)
      new(a, b)
    end

    def initialize(a, b)
      @a, @b = a, b
    end

    def length_squared
      @length_squared ||= (b.x - a.x) ** 2 + (b.y - a.y) ** 2
    end

    def ==(edge)
      (edge.a == a || edge.a == b) &&
        (edge.b == a || edge.b == b)
    end

    def to_s
      "#{a}-#{b}"
    end

    def slope
      @slope ||= a.slope_with(b)
    end

    def contains?(pt)
      return true if pt == a || pt == b

      my_vector = (b - a).normalize
      pt_vector = (pt - a).normalize

      if (my_vector.x - pt_vector.x).abs < 0.001 && (my_vector.y - pt_vector.y).abs < 0.001
        dot_product = (b - a).dot(pt - a)
        dot_product >= 0 && dot_product < length_squared
      else
        false
      end
    end
  end
end
