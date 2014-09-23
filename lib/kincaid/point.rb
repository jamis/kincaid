module Kincaid
  class Point
    attr_reader :x, :y

    def self.[](x, y)
      new(x, y)
    end

    def initialize(x, y)
      @x, @y = x, y
    end

    def -(pt)
      Point[x - pt.x, y - pt.y]
    end

    def ==(pt)
      (pt.x - x).abs < 0.001 &&
        (pt.y - y).abs < 0.001
    end

    def dot(pt)
      pt.x * x + pt.y * y
    end

    def magnitude_squared
      @magnitude_squared ||= x * x + y * y
    end

    def magnitude
      @magnitude ||= Math.sqrt(magnitude_squared)
    end

    def normalize
      Point[x / magnitude, y / magnitude]
    end

    def slope_with(pt)
      slope = if x == pt.x
          nil
        else
          (y - pt.y) / (x - pt.x).to_f
        end

      (slope && slope.abs < 0.001) ? 0 : slope
    end

    def to_s
      "(#{x},#{y})"
    end
  end
end
