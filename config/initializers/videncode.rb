module Paperclip

  class Videncode < Processor

    def initialize file, options = {}, attachment = nil
      @file               = file
      @format             = options[:format]
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
			if @format == 'flv'
				"-i #{File.expand_path(@file.path)} -f flv -y -ar 44100 #{File.expand_path(outfile.path)}"
			elsif @format == 'mp4'
				"-i #{File.expand_path(@file.path)} -f mp4 -y -vcodec libx264 -b 250k -bt 50k -acodec libfaac -ab 56k -ac 2 -s 480x320 #{File.expand_path(outfile.path)}"
			end
		end
  end

end
