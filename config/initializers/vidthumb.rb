module Paperclip

  class Vidthumb < Processor

    def initialize file, options = {}, attachment = nil
      @file               = file
      @format             = 'jpg'
      @options            = options
      @current_format     = File.extname(@file.path)
      @basename           = File.basename(@file.path, @current_format)
    end

    def make
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode
      begin
				Paperclip.run 'ffmpeg', cmd(dst)
      end
      dst
    end
		
		def cmd outfile
			"-i #{File.expand_path(@file.path)} -an -ss 00:00:03 -an -r 1 -vframes 1 -y #{File.expand_path(outfile.path)}"
		end
  end

end
