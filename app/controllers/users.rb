get '/users/new' do
  # note the view is in views/users/new.erb
  # we need the quotes because otherwise
  # ruby would divide the symbol :users by the
  # variable new (which makes no sense)
  @user = User.new
  erb :"users/new"
end

post '/users' do
  # we just initialize the object, w/o saving it, it may be invalid
  @user = User.new(:email => params[:email], 
                  :password => params[:password],
                  :password_confirmation => params[:password_confirmation])
    # the user.id will be nil if the user wasn't saved
    # cos of password mismatch
  if @user.save
    session[:user_id] = @user.id
    redirect to('/')
    # if its not valid, show the same form again
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :"users/new"
  end
end