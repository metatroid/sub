module Paperclip
  module Interpolations
    def random_string(attachment, style)
      (Time.now.to_i*rand()).to_s.gsub('.', '')
    end
  end
end