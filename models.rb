require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'

DataMapper::Logger.new($stdout, :debug) #Uncomment for DataMapper logging
DataMapper.setup(:default, 'mysql://robologger:robologger@powermon/robologger')

class Log
  include DataMapper::Resource
  has n, :log_errors

  before :destroy do
    self.log_errors.each {|le| le.destroy }
  end

  property :id,             Serial, :key => true
  property :name,           String
  property :output,         Text, :length => 2 **32 - 1
  property :created_at,     DateTime

  def find_all_active_errors
    count = 0
    logs = Log.all(:name => @name)
    logs.each do |log|
      count += log.log_errors.all(:awk => false).count
    end
    return count
  end

end

class LogError
  include DataMapper::Resource
  belongs_to :log  

  property :id,           Serial, :key => true
  property :text,         Text
  property :created_at,   DateTime
  property :awk,          Boolean, :default => false

end

DataMapper.auto_upgrade!
