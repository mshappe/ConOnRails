class UsersController < ApplicationController
  respond_to :html, :json

  before_filter :redirect_if_cannot_admin, except: [:change_password]
  before_filter :find_user, only: [:show, :edit, :update, :destroy, :change_password]
  before_filter :find_users, only: :index

  # GET /users/new
  # GET /users/new.json
  def new
    @user           = User.new
    @user.volunteer = Volunteer.find_by_id params[:volunteer_id]

    if params[:realname]
      @user.realname = params[:realname]
    end
  end

  # POST /admin/users
  # POST /admin/users.json
  def create
    # user_params = params[:user].reject { |k, v| k == 'volunteer' }
    @volunteer  = Volunteer.find_by_id(params[:user][:volunteer])

    if @volunteer.present?
      @user = @volunteer.create_user user_params
      @volunteer.save
    else
      @user = User.create user_params
    end
    flash[:notice] = "User #{@user.name} was successfully created." if @user.persisted?
    respond_with @user
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    if @user.update_attributes(user_params) && update_volunteer
      flash[:notice] = "User #{@user.name} was successfully updated."
    end

    respond_with @user
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_with @user, location: users_path
  end

  protected

  def find_user
    @user = User.find(params[:id])
  end

  def find_users
    @q     = User.search params[:q]
    @users = @q.result.page(params[:page])
  end

  def redirect_if_cannot_admin
    unless current_user and current_user.can_admin_users?
      redirect_to public_url
    end
  end

  def update_volunteer
    @volunteer = Volunteer.find_by_id(params[:volunteer_id])
    if @volunteer.present? and (@volunteer.user_id.blank? or @volunteer.user_id != @user.id)
      @volunteer.update_attribute(:user_id, @user.id)
    end
  end

  def user_params
    params.require(:user).permit :name, :realname, :password, :password_confirmation, { role_ids: [] }, :volunteer_id
  end
end
