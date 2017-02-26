class Compressor
  def self.compress input_dir, output_dir
    self.new(input_dir, output_dir).compress_all
  end

  def initialize input_dir, output_dir
    raise ArgumentError, "Unable to locate video directory: #{input_dir}" unless File.directory?(input_dir)
    @input_dir, @output_dir = input_dir, output_dir
  end

  def compress_all
    traverse_videos do |src_vid, dest_vid|
      compress_single src_vid, dest_vid
      ap dest_vid
    end
    puts "\n\ndone.\n\n"
  end

  private

  def compress_single src, dest
    cmd = "ffmpeg -i \"#{src}\" -acodec mp2 \"#{dest}\""
    Open3.popen2e(cmd) do |stdin, stdout_err, wait_thr|
      while line = stdout_err.gets
        puts line
      end

      exit_status = wait_thr.value
      unless exit_status.success?
        abort "FAILED !!! #{cmd}"
      end
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
