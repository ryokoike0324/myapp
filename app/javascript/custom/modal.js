document.addEventListener('DOMContentLoaded', (event) => {
  const openModalButton = document.querySelector('[data-open-modal]');
  const closeModalButton = document.querySelector('[data-close-modal]');
  const modal = document.querySelector('#confirmationModal');

  if (openModalButton) {
      openModalButton.addEventListener('click', function() {
          modal.classList.remove('hidden');
      });
  }

  if (closeModalButton) {
      closeModalButton.addEventListener('click', function() {
          modal.classList.add('hidden');
      });
  }
});
