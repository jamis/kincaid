require 'prawn'
require 'kincaid/page'

module Kincaid
  class Map
    attr_reader :name

    def initialize(name)
      @name = name
      @pages = []
    end

    def new_page(title)
      @pages << Page.new(self, title)
      yield @pages.last
    end

    def to_pdf
      pdf = Prawn::Document.new

      @pages.each_with_index do |page, index|
        pdf.start_new_page unless index == 0
        page.render(pdf)
      end

      pdf
    end
  end
end
