require 'rubygems'
require 'yaml'
require File.dirname(__FILE__) + '/models'

config = YAML::load(File.read(File.dirname(__FILE__) + '/config.yml'))

Dir.chdir(config['parsing']['path_to_logs'])
log_files = Dir.glob("*.txt")
log_files.each do |log|
  log_name = log.gsub(/.txt/, "").upcase
  errors = []
  parsed_log_output = ""
  puts log_name + "was parsed.."
  File.open(log).each do |line|
    if line.scan(/error/i).length > 0
      errors << "<span class='error'>" + line + "</span><br />"
      parsed_log_output += errors.last
    else
      parsed_log_output += line + '<br />'
    end
  end
  db_log = Log.create(:output => parsed_log_output, :name => log_name)
  errors.each do |e|
    db_log.log_errors.create(:text => e)
  end
  File.delete(log)
end
