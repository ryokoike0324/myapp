import consumer from "./consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
      // ActionCable.server.broadcastにより送られたデータ(data)
      // データを受信したときの処理
    console.log(data.notification_count)
    const notificationElement = document.querySelector('#notification-icon');
    const countElement = document.querySelector('#notification-count');

    if (data.notification_count > 0) {
      countElement.textContent = data.notification_count;
      countElement.classList.remove('hidden'); // 未読通知数を表示
      notificationElement.classList.add('bg-yellow-400');
    } else {
      countElement.classList.add('hidden'); // 未読通知がない場合は非表示
      notificationElement.classList.remove('bg-yellow-400')
    }
  }
});
