module TagUtil 
  
  # helper for parseMarkup
  def self.appendChar(args, i, c)
    if args[i] == nil 
      args[i] = c
    else 
      args[i] << c
    end
  end

  # parse a string of arguments separated by spaces
  # arguments may be quoted to capture spaces
  # backslash to escape delimiters or spaces
  # e.g. 
  #   <empty string>     -> []
  #   <spaces>           -> []
  #   foo                -> ["foo"]
  #   foo bar            -> ["foo", "bar"]
  #     foo   bar        -> ["foo", "bar"]
  #   foo 'bar quux'     -> ["foo", "bar quux"]
  #   foo bar\ quux      -> ["foo", "bar quux"]
  #   foo "'bar quux'"   -> ["foo", "'bar quux'"]
  #   foo "\"bar quux\"" -> ["foo", "\"bar quux\""]
  #
  def self.parseMarkup(markup)
    escaped = false
    inQuote = nil
    args = []
    i = 0
    markup.split("").each do |c|
      if escaped 
        self.appendChar(args, i, c)
        escaped = false
      else
        if c == '\\'
          escaped = true 
        else 
          if inQuote != nil
            if c == inQuote
              i += 1
              inQuote = nil
            else
              self.appendChar(args, i, c)
            end
          else
            if c.match(/['"]/) 
              inQuote = c
            elsif c.match(/\s/) 
              if args[i] != nil
                i += 1
              end
            else
              self.appendChar(args, i, c)
            end
          end
        end
      end
    end

    return args
  end


end

