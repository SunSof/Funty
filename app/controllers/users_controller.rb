class UsersController < ApplicationController
  before_action :auth_user, only: %i[edit update show destory]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    render :edit
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path
  end

  def google_auth
    redirect_to GoogleAuth.new.auth_url, allow_other_host: true
  end

  def google_callback
    param_code = params['code']
    @user = User.new(GoogleAuth.new.get_user_info(param_code))
    @user.save(validate: false)
    auto_login(@user)
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def auth_user
    redirect_to root_path unless params[:id].to_s == current_user.id.to_s
  end
end
