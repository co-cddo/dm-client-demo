class UsersController < ApplicationController
  before_action :authenticate_user!

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    user
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    # Users will authenticate via google rather than a password.
    # Creating a random password here as Devise often assumes a password is present.
    # So system is a little simpler if one is present.
    auto_generate_password

    if @user.save
      redirect_to user, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    return redirect_to(user, alert: "Only admins can edit users") unless current_user.admin?

    if user.update(user_params)
      redirect_to user, notice: "User was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    return redirect_to(user, alert: "Only admins can remove users") unless current_user.admin?
    return redirect_to(user, alert: "You cannot remove yourself") if current_user == user

    user.destroy!
    redirect_to users_path, notice: "User was successfully removed.", status: :see_other
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def user
    @user ||= User.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.expect(user: %i[email admin])
  end

  def auto_generate_password
    user.password = Devise.friendly_token
  end
end
