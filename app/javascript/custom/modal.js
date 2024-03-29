document.addEventListener('turbo:load', setupModalTriggers);
document.addEventListener('turbo:frame-load', setupModalTriggers);

function setupModalTriggers() {
    const openModalButtons = document.querySelectorAll('[data-open-modal]');
    const closeModalButtons = document.querySelectorAll('[data-close-modal]');
    const modal = document.querySelector('#confirmationModal');
  
    // モーダルを開くボタンが複数存在する場合を考慮して、forEachを使用
    openModalButtons.forEach(button => {
      button.addEventListener('click', () => {
        const modalId = button.getAttribute('data-open-modal');
        const modal = document.querySelector('#' + modalId);
        modal.classList.remove('hidden');
      });
    });
  
    // モーダルを閉じるボタンにイベントリスナーを設定
    closeModalButtons.forEach(button => {
      button.addEventListener('click', () => {
        const modalId = button.getAttribute('data-close-modal');
        const modal = document.querySelector('#' + modalId);
        modal.classList.add('hidden');
      });
    });
  
    // 'data-submit-close-modal'属性を持つすべてのボタンに対して処理を適用
    document.querySelectorAll('[data-submit-close-modal]').forEach(button => {
      button.addEventListener('click', () => {
        // ボタンがクリックされたらモーダルを閉じる
        // if (modal) {
          modal.classList.add('hidden');
        // }
      });
    });
  }
  
  // 初回読み込み時にも設定を適用
setupModalTriggers();
