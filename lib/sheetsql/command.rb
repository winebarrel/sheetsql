module Sheetsql::Command
  module HashInitializable
    def initialize(attrs = {})
      attrs.each do |name, value|
        send("#{name}=", value)
      end
    end
  end

  def self.define(name, *attrs)
    clazz = Struct.new(*attrs)
    clazz.send(:include, HashInitializable)
    const_set(name, clazz)
  end

  define :ShowSpreadsheets, :like
  define :ShowWorksheets, :title, :like
  define :CreateSpreadsheet, :title
  define :CreateWorksheet, :spreadsheet, :title
  define :DropSpreadsheet, :title
  define :DropWorksheet, :spreadsheet, :title
end
