class RoomChannel < ApplicationCable::Channel
  def subscribed
    logger.info "Subscribed to RoomChannel, roomId: #{params[:roomId]}"

    @room = Room.find(params[:roomId])
    logger.info "#{amount_of_connections(current_user, @room)}"

    stream_from "room_channel_#{@room.id}"

    speak('message' => '* * * joined the room * * *') if amount_of_connections(current_user, @room) == 1
  end

  def unsubscribed
    @room = Room.find(params[:roomId])
    # Any cleanup needed when channel is unsubscribed
    logger.info "#{amount_of_connections(current_user, @room)}"
    speak('message' => '* * * left the room * * *') if amount_of_connections(current_user, @room) == 1
  end

  def speak(data)
    logger.info "RoomChannel, speak: #{data.inspect}"

    MessageService.new(
      body: data['message'], room: @room, user: current_user
    ).perform
  end

  private

  def amount_of_connections(user, room)
    ActionCable.server.connections.count do |con|
      con.current_user == user && con.subscriptions.identifiers.any? { |i| i.match?("\"roomId\":#{room&.id}") }
    end
  end
end
