class RoomsController < ApplicationController
  before_action :set_room, only: [:show]

  def index
    @rooms = Room.all
    @room = Room.new
    @users = User.where(online: true)
  end

  def show
    @messages = Message.eager_load(:user).where(room: @room)
  end

  def create
    @room = Room.create!

    redirect_to @room, notice: 'Room was successfully created.'
  end

  private

  def set_room
    @room = Room.find_by(token: params[:token])
  end
end
