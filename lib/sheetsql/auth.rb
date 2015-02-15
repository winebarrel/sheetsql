class Sheetsql::Auth
  class << self
    def auth(options)
      self.new(options).auth
    end
  end # of class methods

  def initialize(options)
    @options = options
  end

  def auth
    # XXX:
    email = @options.fetch(:email)
    passwd = @options.fetch(:passwd)
    GoogleDriveV0.login(email, passwd)
  end
end
