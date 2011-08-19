require 'sinatra'
require 'haml'
require 'fileutils'
require './about.rb'
require 'dm-core'
require 'dm-timestamps'

DataMapper.setup(:default, "postgres://lambasino:1@localhost/dreen")
class Shot
  include DataMapper::Resource

  property :id,         Serial     # primary serial key
  property :name,       String    # cannot be null
  property :created_at, DateTime

end
DataMapper.finalize

set :haml, :format => :html5 # default Haml format is :xhtml

get '/' do
    @pictures = Shot.all

	foo = "fghjk"
    haml :index, :locals => { :bar => foo }  
end

get '/loadmore':

end

get '/upload' do
	FileUtils.mkdir_p('public/shots') if !File.exist?('public/shots')
	@msg = "Select a file first"
    haml :upload
end

# upload with:
# curl -v -F "file=@a.png" http://localhost:4567/upload
post '/upload' do
	FileUtils.mkdir_p('public/shots') if !File.exist?('public/shots')
    
	unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
      @msg = "Select a file first"
      return haml :upload
    end
    
    r = Random.new
    name = r.rand(1...1000000).to_s() + name

    filename = "public/shots/#{name}" 
    FileUtils.cp tmpfile, filename


    @msg = "wrote to #{filename}\n"
    @shot = Shot.new :name => name, :created_at => Time.now
    @shot.save
    haml :upload
end

get '/page/:page' do |page|
	#a = About.new
	bar = "sa"
	haml :index, :locals => {:page => page, :bar => bar}
end
