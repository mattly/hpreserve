require 'time'
require 'date'

class Proc
  def to_hpreserve
    self.call
  end
end

class Time
  def to_hpreserve
    { 'default' => self.rfc2822, 'year' => self.year, 'month' => self.month, 'day' => self.day,
      'short' => self.strftime('%e %b %y, %H:%M'), 'long' => '%A %e %B %Y, %I:%M%p' }
  end
end