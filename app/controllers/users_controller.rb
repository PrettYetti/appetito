class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :add_friend, :remove_friend]

  # GET /users
  # GET /users.json
  def index
    input = params[:search]
    if input.length > 2
      sql = "name LIKE '%#{input}%' OR email LIKE '%#{input}%'"
    else
      sql = "name LIKE '#{input.titleize}%' OR email LIKE '#{input}%'"
    end
    @users = User.where(sql)
    @users_avatars = @users.map { |user| {avatar_url: user.avatar.url(:icon), id: user.id}}
    @friends = current_user.friends
    respond_to do |format|
      format.html { render :index }
      format.json { render json: {users: @users, user_avatars: @users_avatars, friends: @friends, current_user_id: current_user.id}}
    end

  end

  # GET /users/1
  # GET /users/1.json
  def show
    @events = @user.events
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user.authenticate(params[:password])
      session[:user_id] = @user.id
    else
      render "/"
    end
    redirect_to events_path
  end

  def logout
    reset_session
    redirect_to "/"
  end

  def add_friend
    if @user.privacy
      @user.friend_requests.create(sender_id: current_user.id)
    else
      current_user.friend_ids=current_user.friend_ids.push(@user.id)
    end
    respond_to do |format|
      format.json { render json: {name: @user.name, id: @user.id, privacy: @user.privacy}}
    end
  end

  def remove_friend
    Friendship.find_by(user_id:current_user.id, friend_user_id: @user.id)
    render :show
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
    end
end
