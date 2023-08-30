class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @prototypes = Prototype.all.where(user_id: @user.id)
  end
end
