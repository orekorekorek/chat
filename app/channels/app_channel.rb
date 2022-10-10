class AppChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'app_channel'
    unless current_user.online
      current_user.update(online: true)
      online
    end
  end

  def unsubscribed
    if amount_of_connections(current_user) == 0
      current_user.update(online: false)
      online
    end
  end

  def online
    logger.info 'AppChannel online'

    OnlineService.new(user: current_user).perform
  end

  private

  def amount_of_connections(user)
    ActionCable.server.connections.count { |con| con.current_user == user }
  end
end
