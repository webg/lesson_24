require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

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
	
	f= File.open "./public/user.txt", "a"
	f.write "User: #{@name}, Phone: #{@phone}, Date: #{@date}, Barber: #{@barber}, Color: #{@color} \n"
	f.close
	
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