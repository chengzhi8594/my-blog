class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update]
    before_action :require_same_user, only: [:edit, :update, :destroy]
    before_action :require_admin, only: [:destroy]
    
    def show
        @articles = @user.articles.paginate(page: params[:page], per_page: 5)
    end
    
    def destroy
        @user = User.find(params[:id])
        @user.destroy
        flash[:notice] = "User and all articles created by user have been deleted"
        redirect_to users_path
    end
    
    def index
        @users = User.paginate(page: params[:page], per_page: 5)
    end
    
    
    def new
        @user = User.new
    end
    
    def edit
    end
    
    def update
        if @user.update(user_params)
            flash[:notice] = "Your account information was successfully updated"
            redirect_to @user
        else
            render 'edit'
        end
    end
    
    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            flash[:notice] = "Welcome to the MY-BLOG #{@user.username}, you have successfully signed up"
            redirect_to user_path(@user)
        else
            render 'new'
        end
    end
    
    private
    def user_params
        params.require(:user).permit(:username, :email, :password)
    end
    
    def set_user
        @user = User.find(params[:id])
    end
    
    def require_same_user
        if current_user != @user and !current_user.admin?
            flash[:notice] = "You can only edit your own account"
            redirect_to root_path
        end
    end
    
    def require_admin
        if logged_in? and !current_user.admin?
            flash[:notice] = "Only admin users can perform that action"
            redirect_to root_path
        end
    end
    
end
