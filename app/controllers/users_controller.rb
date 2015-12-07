class UsersController < ActionController::Base
  def index
    @users = User.all
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @users, status: :ok }
    end
  end
end
