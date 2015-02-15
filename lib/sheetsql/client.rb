class Sheetsql::Client
  def initialize(session)
    @driver = Sheetsql::Driver.new(session)
  end

  def query(sql)
    command = Sheetsql::Parser.parse(sql)
    @driver.run(command)
  end
end
