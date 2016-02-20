require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
    db = get_db
    	db.execute 'CREATE TABLE IF NOT EXISTS
        	"Users"
        	(
            	"id" INTEGER PRIMARY KEY AUTOINCREMENT,
            	"name" TEXT,
            	"phone" TEXT,
            	"datestamp" TEXT,
            	"barber" TEXT,
            	"color" TEXT
        	)'
end
get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error = 'something'
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do

	@name=params[:username]
	@phone=params[:phone]
	@date=params[:datetime]
	@barber=params[:barber]
    @color=params[:color]
    
    hh={:username=>"Введите имя", 
    	:phone=>"#{@name} введитете номер телефона", 
    	:datetime=>"#{@name} введите время",
    	:barber=>"#{@name} выберите парикмахера"}
    #hh.each do |key, value|
    #	if params[key]==""
    #		@error=hh[key]
    #		return erb :visit
    #	end
    #   end
    @error = hh.select {|key,_| params[key]==""}.values.join(", ")
    if @error!= ''
    	return erb :visit
    end
	
	db = get_db
    db.execute 'insert into
        Users
        (
            name,
            phone,
            datestamp,
            barber,
            color
        )
        values (?, ?, ?, ?, ?)', [@name, @phone, @date, @barber, @color]
	
    erb "#{@name}, Вы записаны к парикмахеру #{@barber} на #{@date}. В ближайщее время на Ваш номер #{@phone} позвонит наш менджер"
end

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	@email=params[:email]
	@text=params[:text]
	

	f= File.open "./public/contacts.txt", "a"
	f.write "\n Email: #{@email}\n ========================== \n Text: #{@text}\n ================= \n "
	f.close
	erb :contacts
end

def get_db
    db = SQLite3::Database.new 'barbershop.db'
    db.results_as_hash = true
    return db
end