module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :user_type
    # コネクションidであり、後で特定のコネクションを見つけるときに利用
    # 接続を識別するためのキーとして:current_userを設定する
    # HTTP とは異なり毎回認証情報が送られたりはしないので、コネクション確立時に「このコネクションは誰のものか」をサーバー側で管理する

    # クライアントがWebSocketを介してサーバーに接続しようとしたときに、サーバー側で最初に呼び出されるメソッド
    # 目的は、接続を確立する前に特定の認証や許可の処理を行うこと
    def connect
      self.current_user = find_verified_user
      self.user_type = find_verified_user_type
    end

    private

    def find_verified_user
      # Deviseが複数のスコープを扱っている場合、それぞれをチェックする
      verified_user = env['warden'].user(:client) || env['warden'].user(:contractor)
      if verified_user
        verified_user
      else
        # 認証されていないユーザーや不正な接続を検出した場合に呼び出され、WebSocket接続の確立を拒否する
        # ログインユーザーのみがWebSocketを通じてリアルタイムの通信を行えるようにする
        reject_unauthorized_connection
      end
    end

    def find_verified_user_type
      if env['warden'].user(:client)
        :client
      elsif env['warden'].user(:contractor)
        :contractor
      end
    end
  end
end
