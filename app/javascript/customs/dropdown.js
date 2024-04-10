document.addEventListener('turbo:load', setupDropdownTriggers);
document.addEventListener('turbo:frame-load', setupDropdownTriggers);

function setupDropdownTriggers() {
  const toShowClasses = ['opacity-100', 'scale-100'];
  const toHideClasses = ['opacity-0', 'scale-95'];

  const dropdowns = document.querySelectorAll('.dropdown');

  dropdowns.forEach(dropdown => {
    const trigger = dropdown.querySelector('.dropdown-trigger');
    const menu = dropdown.querySelector('.dropdown-menu');

    if (trigger === null || menu === null) return;

    menu.classList.add(...toHideClasses, 'transition', 'duration-100', 'ease-out');

    menu.addEventListener('transitionend', () => {
      if (toHideClasses.every(c => menu.classList.contains(c))) {
        menu.classList.add('hidden');
      }
    });

    trigger.addEventListener('click', () => {
      if (menu.classList.contains('hidden')) {
        menu.classList.remove('hidden');
        setTimeout(() => {
          menu.classList.remove(...toHideClasses);
          menu.classList.add(...toShowClasses);
        }, 0);
      } else {
        menu.classList.remove(...toShowClasses);
        menu.classList.add(...toHideClasses);
      }
    });
  });

  document.addEventListener('click', event => {
    if (event.target) {
      const target = event.target;
      if (target.closest('.dropdown-menu')) {
        return;
      }
    }

    dropdowns.forEach(dropdown => {
      const menu = dropdown.querySelector('.dropdown-menu');
      if (menu === null) return;

      menu.classList.remove(...toShowClasses);
      menu.classList.add(...toHideClasses);
    });
  });
}