
require "coverage"
require "fileutils"

require "simplecov"
require "multi_json"
require "lockfile"

require "easycov/filters"

module EasyCov

  include EasyCov::Filters

  class << self
    attr_accessor :root, :path, :resolve_symlinks

    # Start coverage engine
    # Can be run multiple times without side-effect.
    def start
      return if ENV["DISABLE_EASYCOV"] == "1"
      @resolve_symlinks = true if @resolve_symlinks.nil?
      @path ||= File.expand_path("coverage")
      @root ||= Dir.pwd # only set first time
      Coverage.start
    end

    # Dump coverage to disk in a thread-safe way
    def dump
      return if ENV["DISABLE_EASYCOV"] == "1"
      Coverage.start # always make sure we are started

      FileUtils.mkdir_p(@path)

      if ENV["PARALLEL_EASYCOV"] == "1" then
        # in parallel mode, write output to separate files for each process
        # to be merged later, via #merge
        write_json(File.join(@path, ".tmp.#{$$}.resultset.json"))
        return
      end

      # default is to lock the output file
      output = File.join(@path, ".resultset.json")
      EasyCov.lock(output) do
        write_json(output)
      end

    end # dump

    # Write coverage to disk and restart
    def checkpoint
      dump()
      start()
    end

    # List of filters
    def filters
      @filters ||= []
    end

    # Add filter block
    def filter(&block)
      filters << block
    end

    # Set path to coverage dir
    def path=(path)
      @path = File.expand_path(path)
    end

    def install_exit_hook
      return if ENV["DISABLE_EASYCOV"] == "1"
      Kernel.at_exit do
        EasyCov.checkpoint
      end
    end

    # Merge all temporary coverage files into main file
    def merge!

      output = File.join(@path, ".resultset.json")
      files = [ output ] + Dir.glob(File.join(@path, ".tmp.*.resultset.json"))

      data = {}
      files.each do |f|
        next if !File.exists? f
        data.merge!(MultiJson.load(File.read(f)))
      end

      # write to final dest
      File.open(output+".tmp", 'w'){ |f| f.write(MultiJson.dump(data)) }
      File.rename(output+".tmp", output)
    end

    # Create a flock on the given file
    #
    # @param [String] lockfile    to lock on
    # @param [Block]
    def lock(lockfile, &block)
      lockfile = "#{lockfile}.lock"

      FileUtils.touch(lockfile)
      lock = File.new(lockfile)
      lock.flock(File::LOCK_EX)

      block.call()

      begin
        lock.flock(File::LOCK_UN)
      rescue
      end

      begin
        File.delete(lockfile)
      rescue
      end
    end



    private

    # Apply filters
    def apply_filters(result)

      ret = {}

      if @resolve_symlinks then
        # resolve any symlinks in paths
        result.each do |file,cov|
          next if not File.exists? file
          f = File.realpath(file)
          if f != file then
            ret[f] = cov
          else
            ret[file] = cov
          end
        end

      else
        ret = result.dup
      end

      # apply filters
      filters.each do |filter|
        ret.delete_if { |file, cov|
          filter.call(file)
        }
      end

      return ret
    end

    def write_json(output)
      # load existing if avail
      data = File.exists?(output) ? MultiJson.load(File.read(output)) : {}

      # merge our data
      result = apply_filters(Coverage.result)

      time = Time.new
      name = "Test #{time.strftime('%Y%m%d.%H%M%S')} #{Random.rand(1_000_000)}"
      data[name] = {
        :coverage  => result,
        :timestamp => time.to_i
      }

      # write to tmp file then move, in case we err out
      File.open(output+".tmp", 'w'){ |f| f.write(MultiJson.dump(data)) }
      File.rename(output+".tmp", output)
    end

  end # self

  TOP_PID = Process.pid
end

# Patch to use our path
module SimpleCov
  class << self
    def coverage_path
      EasyCov.path
    end
  end
end
