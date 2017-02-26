class Compressor
  def self.compress input_dir, output_dir
    self.new(input_dir, output_dir).compress
  end

  def initialize input_dir, output_dir
    raise ArgumentError, "Unable to locate video directory: #{input_dir}" unless File.directory?(input_dir)
    @input_dir, @output_dir = input_dir, output_dir
  end

  def compress
    traverse_videos do |src_vid, dest_vid|
      ap [src_vid, dest_vid]
    end
  end

  def traverse_videos
    Dir.glob(File.join(@input_dir, '**', '*.{mp,MP}4')) do |file|
      dest_vid = file.gsub @input_dir, @output_dir
      dest_dir = File.dirname dest_vid
      FileUtils.mkdir_p(dest_dir) unless File.directory?(dest_dir)
      yield file, dest_vid
    end
  end
end
