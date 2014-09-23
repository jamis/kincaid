module Kincaid; module Decorations
  class Window
    def initialize(origin, options)
      @origin = origin
      @options = options
    end

    def render(pdf, setting)
      if @options[:width]
        x1 = @origin.x
        y1 = @origin.y + 0.5
        width = @options[:width]
        height = 1
      else
        x1 = @origin.x - 0.5
        y1 = @origin.y + @options[:height]
        width = 1
        height = @options[:height]
      end

      x1 = setting[:x_ofs] + x1 * setting[:unit_size]
      y1 = setting[:y_ofs] + y1 * setting[:unit_size]

      width *= setting[:unit_size]
      height *= setting[:unit_size]

      pdf.stroke_color "000000"
      pdf.stroke do
        if @options[:width]
          pdf.line x1, y1, x1, y1-height
          pdf.line x1+width, y1, x1+width, y1-height
        else
          pdf.line x1, y1, x1+width, y1
          pdf.line x1, y1-height, x1+width, y1-height
        end
      end
    end
  end
end; end
