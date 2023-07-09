class String #Нужно для придания цвета тексту, без гемов - круто!
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def cyan
    colorize(36)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def underline
    "\e[4m#{self}\e[24m"
  end

  def italic
    "\e[3m#{self}\e[23m"
  end

  def is_upper?
    self == self.upcase
  end

  def is_lower?
    self == self.downcase
  end
end

