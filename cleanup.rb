require 'rubygems'
require File.dirname(__FILE__) + '/models'

Log.all(:created_at.lt Time.now - 604800).each do |l|
  l.destroy
end

