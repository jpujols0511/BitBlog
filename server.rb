require "sinatra"
require "sinatra/activerecord"
require "bcrypt"


ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: './database.sqlite3')

set :database, {adapter: "sqlite3", database: "./database.sqlite3"}

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

get "/" do
  puts "Running"
  erb :home
end

post "/" do
  @blog = Blog.new(params["blog"])
  @blog_id = session[:user_id]
 if @blog.save
   @blogs = Blog.all
   erb :home
 else
   p "Error the blog was not saved"
 end
end

get "/blogs" do
  @blogs = Blog.all
  erb :'users/blog'
end

post "/blog" do
  @blogs = Blog.all
  erb :'users/myposts'
end

get "/signup" do
  @user = User.new
  erb :'users/signup'
end

post "/signup" do
  @user = User.new(params)
  @user.password = params[:password]

  if @user.save!
    p "#{@user.first_name} was saved to the database"
    redirect "/thanks"
  end
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
  @user = User.find_by(email: params['email'])
  if @user
    if @user.password == params[:password]
      p "User authenticated succesfuly"
      session[:user_id] = @user.id
      session[:name] = "#{@user.first_name} #{@user.last_name}"

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
