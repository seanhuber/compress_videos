desc 'scans a directory for video files and compresses them using ffmpeg'
task compress: :environment do
  input_dir  = 'input_dir'
  output_dir = 'output_dir'
  Compressor.compress input_dir, output_dir
end

# http://blog.bigbinary.com/2012/10/18/backtick-system-exec-in-ruby.html
desc 'testing streaming of process output to the terminal'
task popen2e_test: :environment do
  cmd = 'ping www.google.com'
  start_time = Time.now
  Open3.popen2e(cmd) do |stdin, stdout_err, wait_thr|
    while line = stdout_err.gets
      puts line
      Process.kill('KILL', wait_thr.pid) if Time.now - start_time > 10.seconds
    end

    exit_status = wait_thr.value
    unless exit_status.success?
      abort "FAILED !!! #{cmd}"
    end
  end
  puts "done!"
end
