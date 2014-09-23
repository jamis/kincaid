module Kincaid; module Decorations
  class Stairs
    def initialize(direction, orientation, origin, width, height)
      @direction = direction
      @orientation = orientation
      @origin = origin
      @width = width
      @height = height
    end

    def vertical?
      @orientation == :north || @orientation == :south
    end

    def render(pdf, setting)
      pdf.stroke_color = "000000"

      if vertical?
        render_vertical(pdf, setting)
      else
        render_horizontal(pdf, setting)
      end
    end

    def render_vertical(pdf, setting)
      steps = @height
      width_delta = (@width - 1) / steps.to_f

      if @orientation == :north && @direction == :up || @orientation == :south && @direction == :down
        transform = ->(y) { @origin.y + @height - y }
      else
        transform = ->(y) { @origin.y + y }
      end

      pdf.stroke do
        y = 0
        x = setting[:x_ofs] + @origin.x * setting[:unit_size]
        width = @width

        while y < @height
          margin = (@width - width) / 2
          lx = setting[:x_ofs] + @origin.x * setting[:unit_size] + margin * setting[:unit_size]
          ly = setting[:y_ofs] + transform[y] * setting[:unit_size]
          pdf.line lx, ly, lx + width * setting[:unit_size], ly
          width -= width_delta
          y += 1
        end
      end
    end

    def render_horizontal(pdf, setting)
      steps = @width
      width_delta = (@height - 1) / steps.to_f

      if @orientation == :east && @direction == :up || @orientation == :west && @direction == :down
        transform = ->(x) { @origin.x + @width - x }
      else
        transform = ->(x) { @origin.x + x }
      end

      pdf.stroke do
        x = 0
        y = setting[:y_ofs] + @origin.y * setting[:unit_size]
        width = @height

        while x < @width
          margin = (@height - width) / 2
          lx = setting[:x_ofs] + transform[x] * setting[:unit_size]
          ly = setting[:y_ofs] + @origin.y * setting[:unit_size] + margin * setting[:unit_size]
          pdf.line lx, ly, lx, ly + width * setting[:unit_size]
          width -= width_delta
          x += 1
        end
      end
    end
  end
end; end
