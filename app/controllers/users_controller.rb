class UsersController < ApplicationController
  def index
    @users = User.all
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @users, status: :ok }
    end
  end

  def profile
    @user = User.find(params[:id])
  end

end
