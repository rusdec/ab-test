document.addEventListener('DOMContentLoaded', function() {
  const toasts = document.getElementById('toasts');
  const createToast = (color, title, messages = []) => {
    const toastElement = document.createElement('div')
    toastElement.classList.add('toast', `toast-${color}`);

    const titleElement = document.createElement('b')
    titleElement.textContent = title; 
    toastElement.append(titleElement);

    messages.forEach(message => {
      const messageElement = document.createElement('span')
      messageElement.textContent = message;
      toastElement.append(messageElement)
    });

    toasts.append(toastElement);
    setTimeout(() => toastElement.remove(), 2500)
  }

  document.getElementById('send-device-token').addEventListener('click', (event) => {
    event.preventDefault();
    event.target.disabled = true;

    const token = `token-${Date.now()}`;
    const startedAt = new Date();

    fetch('/api/v1/devices/experiments', {
      headers: { "Device-Token": token }
    }).then(response => {
      if (response.ok) {
        createToast(
          'success',
          `Токен отправлен!`,
          [token, `Ответ сервера ${new Date() - startedAt}мс`]
        );

        return response.json();
      } else {
        throw new Error(`Ответ сервера ${response.status}`);
      }
    }).then(json => console.log(token, json))
      .catch(error => createToast('error', 'Ошибка!', [error.message]))
      .finally(() => event.target.disabled = false);
  });
});
