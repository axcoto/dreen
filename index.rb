require 'sinatra'
require 'haml'
require 'fileutils'
require './about.rb'

set :haml, :format => :html5 # default Haml format is :xhtml

get '/' do
	foo = "fghjk"
	  haml :index, :locals => { :bar => foo }  
end

get '/upload' do
	FileUtils.mkdir_p('public/shots') if !File.exist?('public/shots')
    
	unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
      @msg = "Select a file first"
      return haml :upload
    end
    
    File.copy(tmpfile, filename)
    
    userdir = File.join("files", params[:name])
	
	filename = File.join(userdir, params[:filename])
	datafile = params[:data]
	# "#{datafile[:tempfile].inspect}\n"
	File.copy(datafile[:tempfile], filename)
	#File.open(filename, 'wb') do |file|
	# file.write(datafile[:tempfile].read)
	#end
	"wrote to #{filename}\n"
    @msg = "File uploaded"
    haml :upload
end

get '/page/:page' do |page|
	#a = About.new
	bar = "sa"
	haml :index, :locals => {:page => page, :bar => bar}
end






