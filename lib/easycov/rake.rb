
require "easycov"
require "simplecov-console"

desc "Display code coverage report"
task :coverage do
  SimpleCov.merge_timeout(86400) # make sure we load all available data
  SimpleCov::Formatter::Console.new.format(SimpleCov.result)

  # run html formatter
  puts
  SimpleCov::ResultMerger.merged_result.format!

  puts
  puts "URL: file://#{SimpleCov.coverage_path}/index.html"
  puts

end
