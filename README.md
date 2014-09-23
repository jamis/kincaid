Kincaid
=======

Kincaid is a DSL for creating dungeon maps (such as you'd use in tabletop
RPG's like Dungeons & Dragons(tm)). It is not a visual tool for creating maps;
it's just a way to take a map you've designed elsewhere (like, on paper) and
formatting it consistently and neatly, perhaps for publication.

It works like this:

    require 'kincaid/map'

    map = Kincaid::Map.new "My Map"
    map.new_page "First Floor" do |page|
      page.rectangle "outline", Kincaid::Point[-10,-10], 20, 20
      page.door :normal, Kincaid::Point[-2.5,-10], width: 5
    end

    map.to_pdf.render_file "map.pdf"

The output is a (potentially) multi-page PDF. Each map is automatically drawn on
a rectangular grid, with each grid cell representing a 5'x5' square. Currently,
the iconography is heavily influenced by the imagery of classic Dungeons & Dragons
map icons.
