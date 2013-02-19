require 'digest/md5'

class String
  def md5
    Digest::MD5.hexdigest(self)
  end
end
