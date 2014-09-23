require 'kincaid/point'
require 'kincaid/edge'

require 'kincaid/decorations/stairs'
require 'kincaid/decorations/door'
require 'kincaid/decorations/window'

module Kincaid
  class Page
    def initialize
      @polygons = {}
      @edges = {}
      @decorations = []
    end

    def rectangle(label, origin, width, height)
      polygon label,
        origin, Point[origin.x+width, origin.y],
        Point[origin.x+width, origin.y+height], Point[origin.x, origin.y+height]
    end

    def wall(edge)
      add_edge(edge)
    end

    def gap(edge)
      remove_edge(edge)
    end

    def polygon(label, *points)
      @polygons[label] = points

      points.each_with_index do |p1, index|
        next_index = (index + 1) % points.length
        p2 = points[next_index]
        add_edge Edge[p1, p2]
      end
    end

    def stairs(direction, orientation, origin, width, height)
      @decorations << Decorations::Stairs.new(direction, orientation, origin, width, height)
    end

    def door(type, origin, options)
      @decorations << Decorations::Door.new(type, origin, options)
    end

    def window(origin, options)
      @decorations << Decorations::Window.new(origin, options)
    end

    def render(pdf)
      min_x = min_y =  1_000_000
      max_x = max_y = -1_000_000

      edges = @edges.values.flatten
      edges.each do |edge|
        local_min_x, local_max_x = [edge.a.x, edge.b.x].minmax
        local_min_y, local_max_y = [edge.a.y, edge.b.y].minmax

        min_x = local_min_x if local_min_x < min_x
        min_y = local_min_y if local_min_y < min_y
        max_x = local_max_x if local_max_x > max_x
        max_y = local_max_y if local_max_y > max_y
      end

      min_x -= 10
      min_y -= 10
      max_x += 10
      max_y += 10

      width  = (max_x - min_x)
      height = (max_y - min_y)

      x_unit_size = pdf.bounds.width / width.to_f
      y_unit_size = pdf.bounds.height / height.to_f

      unit_size = [x_unit_size, y_unit_size].min
      grid_size = 5 * unit_size

      x_ofs = (pdf.bounds.width - width * unit_size) / 2 - min_x * unit_size
      y_ofs = (pdf.bounds.height - height * unit_size) / 2 - min_y * unit_size

      y_top = y_ofs + ((pdf.bounds.height - y_ofs) / unit_size).to_i * unit_size
      x_right = x_ofs + ((pdf.bounds.width - x_ofs) / unit_size).to_i * unit_size

      pdf.stroke_color = "d0d0d0"
      pdf.stroke do
        x = x_ofs
        while x < pdf.bounds.width+0.001
          pdf.line x, 0, x, pdf.bounds.height
          x += grid_size
        end

        x = x_ofs - grid_size
        while x >= 0
          pdf.line x, 0, x, pdf.bounds.height
          x -= grid_size
        end

        y = y_ofs
        while y < pdf.bounds.height+0.001
          pdf.line 0, y, pdf.bounds.width, y
          y += grid_size
        end

        y = y_ofs - grid_size
        while y >= 0
          pdf.line 0, y, pdf.bounds.width, y
          y -= grid_size
        end
      end

      pdf.stroke_color = "000000"
      pdf.stroke do
        edges.each do |edge|
          pdf.line x_ofs + edge.a.x * unit_size, y_ofs + edge.a.y * unit_size,
            x_ofs + edge.b.x * unit_size, y_ofs + edge.b.y * unit_size
        end
      end

      setting = {
        unit_size: unit_size,
        grid_size: grid_size,
        x_ofs:     x_ofs,
        y_ofs:     y_ofs
      }

      @decorations.each do |decor|
        decor.render(pdf, setting)
      end

      #pdf.stroke_color = "ff0000"
      #pdf.stroke do
      #  pdf.line 0, y_ofs, pdf.bounds.width, y_ofs
      #  pdf.line x_ofs, 0, x_ofs, pdf.bounds.height
      #end

      pdf
    end

    private

    def add_edge(edge)
      slope = edge.slope
      candidates = (@edges[slope] ||= [])

      collinear, indirect = candidates.partition do |candidate_edge|
        slope == candidate_edge.a.slope_with(edge.a)
      end

      @edges[slope] = indirect + simplify(collinear.push(edge))
    end

    def remove_edge(edge)
      slope = edge.slope
      candidates = (@edges[slope] || [])

      return if candidates.empty?

      collinear, indirect = candidates.partition do |candidate_edge|
        slope == candidate_edge.a.slope_with(edge.a)
      end

      @edges[slope] = indirect + subtract(collinear, edge)
    end

    def simplify(edges)
      edges.each_with_index do |e1, i1|
        next if e1.nil?

        edges.each_with_index do |e2, i2|
          next if e2.nil? || i1 == i2

          if e1 == e2
            edges[i1] = nil
          else
            has_1a = e2.contains?(e1.a)
            has_1b = e2.contains?(e1.b)
            has_2a = e1.contains?(e2.a)
            has_2b = e1.contains?(e2.b)

            if has_1a && has_1b
              edges[i1] = nil
            elsif has_2a && has_2b
              edges[i2] = nil
            elsif has_1a && has_2a
              # discard both, add new edge between e1.b and e2.b
              edges[i1] = edges[i2] = nil
              edges.push(Edge[e1.b, e2.b])
            elsif has_1a && has_2b
              # discard both, add new edge between e1.b and e2.a
              edges[i1] = edges[i2] = nil
              edges.push(Edge[e1.b, e2.a])
            elsif has_1b && has_2a
              # discard both, add new edge between e1.a and e2.b
              edges[i1] = edges[i2] = nil
              edges.push(Edge[e1.a, e2.b])
            elsif has_1b && has_2b
              # discard both, add new edge between e1.a and e2.a
              edges[i1] = edges[i2] = nil
              edges.push(Edge[e1.a, e2.a])
            else
              # no overlap, keep both
            end
          end
        end
      end

      edges.compact! ? simplify(edges) : edges
    end

    def subtract(edges, target)
      new_edges = []

      edges.each do |edge|
        if edge == target
          # remove the entire edge
        else
          has_ta = edge.contains?(target.a)
          has_tb = edge.contains?(target.b)
          has_ea = target.contains?(edge.a)
          has_eb = target.contains?(edge.b)

          if has_ta && has_tb
            # remove target from edge
            t_mid = Point[(target.b.x + target.a.x) / 2, (target.b.y + target.a.y) / 2]
            a = Edge[edge.a, t_mid]
            b = Edge[edge.b, t_mid]

            if a.contains?(target.a)
              new_edges << Edge[edge.a, target.a]
            else
              new_edges << Edge[edge.a, target.b]
            end

            if b.contains?(target.a)
              new_edges << Edge[edge.b, target.a]
            else
              new_edges << Edge[edge.b, target.b]
            end
          elsif has_ea && has_eb
            # remove the entire edge, as it is entirely contained in target
          elsif has_ta && has_ea
            new_edges << Edge[target.a, edge.b]
          elsif has_ta && has_eb
            new_edges << Edge[target.a, edge.a]
          elsif has_tb && has_ea
            new_edges << Edge[target.b, edge.b]
          elsif has_tb && has_eb
            new_edges << Edge[target.b, edge.a]
          else
            # no overlap, keep entire edge
            new_edges << edge
          end
        end
      end

      new_edges
    end
  end
end
