require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'haml'
require 'json'

class PushInfo 
    include DataMapper::Resource
    property :id, Serial
    property :message, Text
end

configure do 
     DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/development.sqlite3"))
     DataMapper.auto_upgrade!
end

get '/' do 
    @raw_messages = PushInfo.all
    @messages = @raw_messages.collect {|m| JSON.parse(m.message)}
    #p @messages
    haml :dashboard, :layout=>false
end

post '/turnin' do 
    PushInfo.create :message => params[:payload]
    "OK"
end
