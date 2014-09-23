module Kincaid; module Decorations
  class Door
    def initialize(type, origin, options)
      @type = type
      @origin = origin
      @options = options
    end

    def render_normal(pdf, setting)
      if @options[:width]
        x1 = @origin.x + 1
        y1 = @origin.y + 0.5
        width = @options[:width] - 2
        height = 1
      else
        x1 = @origin.x - 0.5
        y1 = @origin.y + @options[:height] - 1
        width = 1
        height = @options[:height] - 2
      end

      x1 = setting[:x_ofs] + x1 * setting[:unit_size]
      y1 = setting[:y_ofs] + y1 * setting[:unit_size]

      width *= setting[:unit_size]
      height *= setting[:unit_size]

      pdf.fill_color = "ffffff"
      pdf.stroke_color = "000000"
      pdf.fill_and_stroke do
        pdf.rectangle [x1, y1], width, height

        if @type == :double
          if @options[:width]
            ofs = width / 2
            pdf.line x1 + ofs, y1, x1 + ofs, y1 - height
          else
            ofs = height / 2
            pdf.line x1, y1 - ofs, x1 + width, y1 - ofs
          end
        end
      end
    end

    def render_secret(mark, pdf, setting)
      if @options[:width]
        rotate = 90
        x = setting[:x_ofs] + @origin.x * setting[:unit_size]
        y = setting[:y_ofs] + @origin.y * setting[:unit_size] + setting[:grid_size]/2
      else
        rotate = 0
        x = setting[:x_ofs] + @origin.x * setting[:unit_size] - 3*setting[:grid_size]/4
        y = setting[:y_ofs] + @origin.y * setting[:unit_size] + @options[:height] + setting[:grid_size]*1.6
      end

      pdf.fill_color "000000"
      pdf.font "Helvetica", size: setting[:grid_size] * 0.75

      pdf.text_box mark, align: :center, valign: :center, rotate: rotate, at: [x+setting[:unit_size]*1.15, y-setting[:grid_size]*0.85], width: setting[:grid_size], height: setting[:grid_size]
    end

    def render(pdf, setting)
      case @type
        when :normal, :double
          render_normal(pdf, setting)
        when :secret
          render_secret("S", pdf, setting)
        when :concealed
          render_secret("C", pdf, setting)
        else
          raise NotImplementedError, "door: #{@type}"
      end
    end
  end
end; end
