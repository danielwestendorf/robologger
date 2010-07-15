require 'rubygems'
require 'sinatra'
require File.dirname(__FILE__) + "/models" 
require 'cgi'

helpers do
  def date_format(date)
    date.strftime("%m/%d/%Y")
  end
end

get "/" do
  logs = repository(:default).adapter.select('SELECT id, name FROM (SELECT id, name FROM logs GROUP BY name ORDER BY name ASC) ORDER BY name ASC')
  @logs = []
  logs.each {|l| @logs << Log.get(l.id)}
  erb :index
end

get "/log/:name" do
  @logs = Log.all(:name => CGI::unescape(params[:name]), :order => [:created_at.desc])
  erb :show
end

get "/log/:id/output" do 
  @output = Log.get(params[:id]).output
end

post "/errors" do
  error = LogError.get(params[:id])
  return 500 if error.nil?
  error.awk = true
  if error.save
    200
  else
    500
  end
end
