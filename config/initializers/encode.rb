module Paperclip

  class Encode < Processor

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
			"-i #{File.expand_path(@file.path)} -f #{@format} -y -ab 192k #{File.expand_path(outfile.path)}"
		end
  end

end
