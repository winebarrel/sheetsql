class Sheetsql::Driver
  def initialize(session)
    @session = session
  end

  def run(command)
    method_name = underscore(command)
    send(method_name, command)
  end

  private

  def show_spreadsheets(command)
    files = @session.files.select do |file|
      file.resource_type == 'spreadsheet'
    end

    if command.like
      re = like_to_regexp(command.like)
      files.reject! {|file| file.title !~ re }
    end

    files.map do |file|
      {
        :title => file.title,
        :url => file.human_url,
      }
    end
  end

  def show_worksheets(command)
    spreadsheet = @session.spreadsheet_by_title(command.title)
    worksheets = spreadsheet.worksheets

    if command.like
      re = like_to_regexp(command.like)
      worksheets.reject! {|worksheet| worksheet.title !~ re }
    end

    worksheets.map do |worksheet|
      {
        :title => worksheet.title,
      }
    end
  end

  def create_spreadsheet(command)
    spreadsheet = @session.create_spreadsheet(command.title)

    {
      :title => spreadsheet.title,
      :url => spreadsheet.human_url,
    }
  end

  def create_worksheet(command)
    spreadsheet = @session.spreadsheet_by_title(command.spreadsheet)
    worksheet = spreadsheet.add_worksheet(command.title)

    {
      :title => worksheet.title,
    }
  end

  def underscore(command)
    class_name = command.class.to_s.split('::').last
    class_name.gsub(/([A-Z]+)/, '_\1').sub(/\A_/, '').downcase
  end

  def like_to_regexp(like)
    ss = StringScanner.new(like)
    retval = ''

    until ss.eos?
      if (tok = ss.scan(/[^%_\\]+/))
        retval << Regexp.escape(tok)
      elsif (tok = ss.scan(/\\/))
        ch = ss.getch
        retval << Regexp.escape(tok) unless %w(% _ \\).include?(ch)
        retval << Regexp.escape(ch) if ch
      elsif (tok = ss.scan(/%/))
        retval << '.*'
      elsif (tok = ss.scan(/_/))
        retval << '.'
      else
        raise 'must not happen'
      end
    end

    Regexp.new(retval)
  end
end
