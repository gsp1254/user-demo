require 'json'
class UsersController < ApplicationController
  protect_from_forgery with: :null_session
  def index
    @users = User.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @users }

     end
  end

  def create
      @user = User.new(user_params)
      @user.save!
      render json: @user
  end

  def filter
      campaign_names = params[:campaign_names].split(",")
      @users = []
      User.all.each do |user|
          json_hash = JSON.parse(user.campaigns_list)
          json_hash.map { |c| @users << user if campaign_names.include?(c["campaign_name"]) }
      end
      render json: @users.uniq
  end

  private
  def user_params
     params.require(:user).permit(:name, :email, :campaigns_list)
  end
end
