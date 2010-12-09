require 'mail'
require 'cgi'
require 'yaml'
require File.dirname(__FILE__) + "/models"

config = YAML::load(File.read(File.dirname(__FILE__) + '/config.yml'))
TO = config['email']['to']
FROM = config['email']['from']
SERVER = config['email']['server']
HOST = config['email']['host']

Mail.defaults do
  delivery_method :smtp, { :address => SERVER }
end

def no_errors
  mail = Mail.new do
    to      TO
    from    FROM 
    subject "There were no replication errors last night <EOM>"
    body    ""
  end
  mail.deliver!
end

def errors(logs_with_errors, error_count)
  msg = "<h2 style='color: red;'>Danger Will Robinson, DANGER!</h2><p>There were #{error_count} replication errors last night</p>"
  logs_with_errors.each do |log|
   msg += "<p><a href='http://#{HOST}/log/#{CGI::escape(log.name)}' style='color: red;'>#{log.name}</a> -- #{log.find_all_active_errors} Errors</p>"
  end       
 

  mail = Mail.new do
    to      TO
    from    FROM
    subject "There were #{error_count} replication errors last night"
    text_part do 
      body "Visit http://#{HOST} for details"
    end
    html_part do
      content_type 'text/html; charset=UTF-8'
      body msg
    end
  end
  mail.deliver!
end

logs = repository(:default).adapter.select('SELECT id, name FROM logs GROUP BY name ORDER BY name')

logs_with_errors = []
error_count = 0
logs.each do |log|
  l = Log.get(log.id)
  errors = l.find_all_active_errors
  logs_with_errors << l if errors > 0
  error_count += errors
end

if error_count < 1
  no_errors
else
 errors(logs_with_errors, error_count)
end 
