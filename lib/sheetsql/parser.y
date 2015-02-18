class Parser
options no_result_var
rule
  stmt : show_stmt
       | create_stmt
       | drop_stmt

  show_stmt : SHOW SPREADSHEETS like_clause
              {
                Sheetsql::Command::ShowSpreadsheets.new(:like => val[2])
              }
            | SHOW WORKSHEETS FROM IDENTIFIER like_clause
              {
                Sheetsql::Command::ShowWorksheets.new(:title => val[3], :like => val[4])
              }

  create_stmt : CREATE SPREADSHEET IDENTIFIER
                {
                  Sheetsql::Command::CreateSpreadsheet.new(:title => val[2])
                }
              | CREATE WORKSHEET IDENTIFIER ON IDENTIFIER
                {
                  Sheetsql::Command::CreateWorksheet.new(:title => val[2], :spreadsheet => val[4])
                }

  drop_stmt : DROP SPREADSHEET IDENTIFIER
                {
                  Sheetsql::Command::DropSpreadsheet.new(:title => val[2])
                }
              | DROP WORKSHEET IDENTIFIER ON IDENTIFIER
                {
                  Sheetsql::Command::DropWorksheet.new(:title => val[2], :spreadsheet => val[4])
                }

  like_clause :
              | LIKE STRING
                {
                  val[1]
                }

---- header

module Sheetsql

---- inner

KEYWORDS = %w(
  CREATE
  DROP
  FROM
  LIKE
  ON
  SHOW
  SPREADSHEETS
  SPREADSHEET
  WORKSHEETS
  WORKSHEET
)

KEYWORD_RE = /#{Regexp.union(KEYWORDS).source}/i

OPERATORS = {
  '<>' => :NE,
  '!=' => :NE,
  '>=' => :GE,
  '<=' => :LE,
  '>'  => :GT,
  '<'  => :LT,
  '='  => :EQ,
}

OPERATOR_RE = Regexp.union(OPERATORS.keys)

def initialize(obj)
  src = obj.is_a?(IO) ? obj.read : obj.to_s
  @ss = StringScanner.new(src)
end

def scan
  tok = nil
  @prev_tokens = []

  until @ss.eos?
    if (tok = @ss.scan(/\s+/))
      # nothing to do
    elsif (tok = @ss.scan(OPERATOR_RE))
      yield [OPERATORS.fetch(tok), tok]
    elsif (tok = scan_keyword(KEYWORD_RE))
      yield [tok.upcase.to_sym, tok]
    elsif (tok = scan_keyword(/NULL/i))
      yield [:NULL, nil]
    elsif (tok = @ss.scan(quoted_re('`')))
      yield [:IDENTIFIER, unquote(tok, '`')]
    elsif (tok = @ss.scan(quoted_re("'")))
      yield [:STRING, unquote(tok, "'")]
    elsif (tok = @ss.scan(quoted_re('"')))
      yield [:STRING, unquote(tok, '"')]
    elsif (tok = @ss.scan(/\d+(?:\.\d+)?/))
      yield [:NUMBER, (tok =~ /\./ ? tok.to_f : tok.to_i)]
    elsif (tok = @ss.scan(/[*.]/))
      yield [tok, tok]
    elsif (tok = @ss.scan(/\w+/))
      yield [:IDENTIFIER, tok]
    else
      raise_error(tok, @prev_tokens, @ss)
    end

    @prev_tokens << tok
  end

  yield [false, '']
end
private :scan

def quoted_re(quotation)
  /#{quotation}(?:\\\\|\\#{quotation}|[^#{quotation}])*#{quotation}/
end
private :quoted_re

def scan_keyword(re)
  if (tok = @ss.check(re)) and @ss.rest.slice(tok.length) !~ /\A\w/
    @ss.scan(re)
  else
    nil
  end
end
private :scan_keyword

def unquote(quoted_value, quotation)
  str = quoted_value.slice(1...-1)
  ss = StringScanner.new(str)
  retval = ''

  until ss.eos?
    if (tok = ss.scan(/[^\\]+/))
      retval << tok
    elsif (tok = ss.scan(/\\/))
      ch = ss.getch
      retval << tok unless [quotation, '\\'].include?(ch)
      retval << ch if ch
    else
      raise 'must not happen'
    end
  end

  retval
end
private :unquote

def raise_error(error_value, prev_tokens, scanner)
  errmsg = ["__#{error_value}__"]

  if prev_tokens and not prev_tokens.empty?
    toks = prev_tokens.reverse[0, 5].reverse
    toks.unshift('...') if prev_tokens.length > toks.length
    errmsg.unshift(toks.join.strip)
  end

  if scanner and not (rest = (scanner.rest || '').strip).empty?
    str = rest[0, 16]
    str += '...' if rest.length > str.length
    errmsg << str
  end

  raise Racc::ParseError, ('parse error on value: %s' % errmsg.join(' '))
end
private :raise_error

def parse
  yyparse self, :scan
end

def on_error(error_token_id, error_value, value_stack)
  raise_error(error_value, @prev_tokens, @ss)
end

def self.parse(obj)
  self.new(obj).parse
end

---- footer

end # Sheetsql
