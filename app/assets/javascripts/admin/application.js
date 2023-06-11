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

    const tokenCountElement = document.getElementById('token-count');
    const tokenCount = Number.parseInt(tokenCountElement.value);
    console.log(tokenCount);
    let timeout = 500;

    for(let i = 0; i < tokenCount; i++) {
      setTimeout(() => {
        if (tokenCountElement.value > 1) {
          tokenCountElement.value -= 1;
        }

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
            throw new Error(`Статус ответа ${response.status}`);
          }
        })
        .then(json => console.log(token, json))
        .catch(error => createToast('error', 'Ошибка!', [error.message]))
        .finally(() => event.target.disabled = false);
      }, timeout += 100);
     }
  });


  document.getElementById('token-count').addEventListener('change', (event) => {
    const value = Number.parseInt(event.target.value)
    const min = Number.parseInt(event.target.min);
    const max = Number.parseInt(event.target.max);

    if (value < min) {
      event.target.value = min;
    } else if (value > max) {
      event.target.value  = max;
    }
  })
});
