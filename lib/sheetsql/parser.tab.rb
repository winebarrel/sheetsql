#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.12
# from Racc grammer file "".
#

require 'racc/parser.rb'


module Sheetsql

class Parser < Racc::Parser

module_eval(<<'...end parser.y/module_eval...', 'parser.y', 46)

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

...end parser.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
     5,     9,    10,    13,    14,     6,    11,    12,    20,     7,
    15,    17,    18,    19,     8,    21,    22,    23,    24,    25,
    26,    17,    28,    29 ]

racc_action_check = [
     0,     5,     5,     7,     7,     0,     6,     6,    12,     0,
     8,     9,    10,    11,     1,    13,    14,    17,    18,    20,
    22,    24,    25,    26 ]

racc_action_pointer = [
    -2,    14,   nil,   nil,   nil,    -2,    -2,    -5,    10,    -1,
     7,     7,     2,     9,    10,   nil,   nil,     4,    12,   nil,
     9,   nil,    10,   nil,     9,    16,    17,   nil,   nil,   nil ]

racc_action_default = [
   -12,   -12,    -1,    -2,    -3,   -12,   -12,   -12,   -12,   -10,
   -12,   -12,   -12,   -12,   -12,    30,    -4,   -12,   -12,    -6,
   -12,    -8,   -12,   -11,   -10,   -12,   -12,    -5,    -7,    -9 ]

racc_goto_table = [
    16,     3,     2,     4,     1,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,    27 ]

racc_goto_check = [
     5,     3,     2,     4,     1,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,     5 ]

racc_goto_pointer = [
   nil,     4,     2,     1,     3,    -9 ]

racc_goto_default = [
   nil,   nil,   nil,   nil,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 15, :_reduce_none,
  1, 15, :_reduce_none,
  1, 15, :_reduce_none,
  3, 16, :_reduce_4,
  5, 16, :_reduce_5,
  3, 17, :_reduce_6,
  5, 17, :_reduce_7,
  3, 18, :_reduce_8,
  5, 18, :_reduce_9,
  0, 19, :_reduce_none,
  2, 19, :_reduce_11 ]

racc_reduce_n = 12

racc_shift_n = 30

racc_token_table = {
  false => 0,
  :error => 1,
  :SHOW => 2,
  :SPREADSHEETS => 3,
  :WORKSHEETS => 4,
  :FROM => 5,
  :IDENTIFIER => 6,
  :CREATE => 7,
  :SPREADSHEET => 8,
  :WORKSHEET => 9,
  :ON => 10,
  :DROP => 11,
  :LIKE => 12,
  :STRING => 13 }

racc_nt_base = 14

racc_use_result_var = false

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "SHOW",
  "SPREADSHEETS",
  "WORKSHEETS",
  "FROM",
  "IDENTIFIER",
  "CREATE",
  "SPREADSHEET",
  "WORKSHEET",
  "ON",
  "DROP",
  "LIKE",
  "STRING",
  "$start",
  "stmt",
  "show_stmt",
  "create_stmt",
  "drop_stmt",
  "like_clause" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

# reduce 1 omitted

# reduce 2 omitted

# reduce 3 omitted

module_eval(<<'.,.,', 'parser.y', 9)
  def _reduce_4(val, _values)
                    Sheetsql::Command::ShowSpreadsheets.new(:like => val[2])
              
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 13)
  def _reduce_5(val, _values)
                    Sheetsql::Command::ShowWorksheets.new(:title => val[3], :like => val[4])
              
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 18)
  def _reduce_6(val, _values)
                      Sheetsql::Command::CreateSpreadsheet.new(:title => val[2])
                
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 22)
  def _reduce_7(val, _values)
                      Sheetsql::Command::CreateWorksheet.new(:title => val[2], :spreadsheet => val[4])
                
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 27)
  def _reduce_8(val, _values)
                      Sheetsql::Command::DropSpreadsheet.new(:title => val[2])
                
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 31)
  def _reduce_9(val, _values)
                      Sheetsql::Command::DropWorksheet.new(:title => val[2], :spreadsheet => val[4])
                
  end
.,.,

# reduce 10 omitted

module_eval(<<'.,.,', 'parser.y', 37)
  def _reduce_11(val, _values)
                      val[1]
                
  end
.,.,

def _reduce_none(val, _values)
  val[0]
end

end   # class Parser


end # Sheetsql
