class Compressor
  def self.compress input_dir, output_dir
    raise ArgumentError, "Unable to locate video directory: #{input_dir}" unless File.directory?(input_dir)
    ap [input_dir, output_dir]
  end
end
