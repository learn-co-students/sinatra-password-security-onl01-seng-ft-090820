require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

	configure do
		set :views, "app/views"
		enable :sessions
		set :session_secret, "password_security"
	end

	get "/" do
		erb :index
	end

	get "/signup" do
		erb :signup
	end

	post "/signup" do
		#your code here!
		#create new user (has a username and password, will be 2 separate key => value pairs)
		#if user is created(saved), redirect to login page
		user = User.new(:username => params[:username], :password => params[:password])
		
		if user.save
			redirect '/login'
		else
			redirect '/failure'
		end
	end

	get "/login" do
		erb :login
	end

	post "/login" do
		#your code here!
		#search database of users based on entry & check if username and password match
		user = User.find_by(:username => params[:username])

		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect '/success'
		else
			redirect '/failure'
		end
	end

	get "/success" do
		if logged_in?
			erb :success
		else
			redirect "/login"
		end
	end

	get "/failure" do
		erb :failure
	end

	get "/logout" do
		session.clear
		redirect "/"
	end

	helpers do
		def logged_in?
			!!session[:user_id]
		end

		def current_user
			User.find(session[:user_id])
		end
	end

end
