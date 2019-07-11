require "sinatra"
require "sinatra/activerecord"
require "bcrypt"
require "action_mailer"
require "shotgun"
require_relative "mailer"

#MAINTENANCE
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: './database.sqlite3')
set :database, {adapter: "sqlite3", database: "./database.sqlite3"}

#
# #DEPLOYMENT
# require "active_record"
# ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])

enable :sessions

class User < ActiveRecord::Base
  include BCrypt
  def password
    @password ||= Password.new(password_hash)
  end
  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end

class Blog < ActiveRecord::Base
end

def send_email(recipient, confirmation, last_name)
  Newsletters.welcome_email(recipient, confirmation, last_name).deliver_now
end
$params = {}
$code = ''

get "/" do
  puts "Running"
  erb :home
end

post "/" do
  @blog = Blog.new(params["blog"])
  @blog_id = session[:user_id]
  if params[:image] && params[:image][:filename]
      @filename = params[:image][:filename]
      file = params[:image][:tempfile]

      File.open("./public/uploads/#{@filename}", 'wb') do |f|
        f.write(file.read)
      end
    end
 if @blog.save
   @blog.update(image_url: @filename)
   @blog.update(user_id: session[:user_id])
   @blog.update(created_by: session[:name])
   @blogs = Blog.all
   erb :home
 else
   p "Error the blog was not saved"
 end
end

get "/blogs" do
  @blogs = Blog.all.order(created_at: :desc)
  erb :'users/blog'
end

get "/myblogs" do
  @blogs = Blog.all
  erb :'users/myposts'
end

get "/settings" do
  erb :'users/settings'
end

get "/signup" do
  @user = User.new
  erb :'users/signup'
end

post "/signup" do
  $params = params
  $code = rand.to_s[2..8]
  send_email(params[:email],$code ,params[:last_name])
  @confirmation_email = params[:email]
  erb :'users/confirmation'

end

post '/users/confirmation' do
  p $params

  if params[:confirmation] == $code
    @user = User.new($params)
    @user.password = $params[:password]
    if @user.save!
      p "#{@user.first_name} was saved to the database"
      redirect "/thanks"
    end
  else
    p "Error Wrong code"
    redirect "/users/confirmation"

  end

end

get "/thanks" do
  erb :'users/thanks'
end


get "/thanks" do
  erb :'users/thanks'
end

get "/login" do
  if session[:user_id]
    redirect "/"
  else
    erb :'users/login'
  end
end

post "/login" do
  @user = User.find_by(email: params[:email])
  if @user
    if @user.password == params[:password]
      p "User authenticated succesfuly"
      session[:user_id] = @user.id
      session[:name] = "#{@user.first_name} #{@user.last_name}"
      session[:email] = @user.email

      redirect "/"
    else
      p "Invalid email or password"
    end
  end
end

get "/profile" do
  erb :'users/profile'
end

post "/delete_user" do
  erb :'users/delete_user'
end

post "/delete_post" do
  erb :'users/delete_post'
end

#DELETE REQUEST
get "/logout" do
  session.clear
  redirect "/"
  p "User logged out succesfully"
end
