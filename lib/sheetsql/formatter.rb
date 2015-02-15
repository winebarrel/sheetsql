class Sheetsql::Formatter
  class << self
    def format(obj)
      JSON.pretty_generate(obj)
    end
  end # of class methods
end
