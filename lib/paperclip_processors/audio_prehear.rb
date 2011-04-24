module Paperclip
  class AudioPrehear < Processor

    attr_accessor :resolution, :whiny

    def initialize(file, options = {}, attachment = nil)
      super
      @file = file
      @whiny = options[:whiny].nil? ? true : options[:whiny]
      @basename = File.basename(@file.path, File.extname(@file.path))
    end

    def make
      target = File.dirname(@file.path) + "/" + @basename + ".wav"

      convert File.expand_path(file.path), target
      dst = File.open target
    end

    def convert ( infile, outfile )
      cmd = "-w #{outfile} #{infile}"
      begin
       success = Paperclip.run('mpg123', cmd, [ 0, 1 ])
      rescue PaperclipCommandLineError
        raise PaperclipError, "There was an error processing the preview for #{@basename}" if whiny
      end
    end
  end
end