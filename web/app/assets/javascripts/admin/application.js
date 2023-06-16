function sendDeviceToken(token, createToast, callback = undefined) {
  const startedAt = new Date();
  return fetch('/api/v1/devices/experiments', {
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
  .then(json => {
    console.log(token, json);
    if (callback) callback(json);
  })
  .catch(error => createToast('error', 'Ошибка!', [error.message]));
}

function experimentsPage(createToast) {
  const buttonRefresh = document.getElementById('refresh');

  document.getElementById('send-device-token').addEventListener('click', (event) => {
    event.preventDefault();
    event.target.disabled = true;
    buttonRefresh.disabled = true;

    const tokenCountElement = document.getElementById('token-count');
    const tokenCount = Number.parseInt(tokenCountElement.value);

    let timeout = 300;
    const timeoutDelta = 130;

    for(let i = 0; i < tokenCount; i++) {
      setTimeout(() => {
        if (tokenCountElement.value > 1) tokenCountElement.value -= 1;
        sendDeviceToken(`token-${Date.now()}`, createToast)
      }, timeout += timeoutDelta);
     }

     setTimeout(() => {
       event.target.disabled = false;
       buttonRefresh.disabled = false;
     }, timeout += timeoutDelta)
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
}

function deviceTokensPage(createToast) {
  const apiButtons = [...document.querySelectorAll('button[data-token]')];
  const apiOutput = document.getElementById('api-output');

  apiButtons.forEach(apiButton => {
    apiButton.addEventListener('click', () => {
      apiOutput.textContent = '';
      sendDeviceToken(apiButton.dataset.token, createToast, (json) => {
        apiOutput.textContent = JSON.stringify(json, null, 2);
      });
    })
  });
}

document.addEventListener('DOMContentLoaded', function() {
  const toasts = document.getElementById('toasts');
  const createToast = (color, title, messages = []) => {
    const toastElement = document.createElement('div')
    toastElement.classList.add('toast', `toast--${color}`);

    const titleElement = document.createElement('b')
    titleElement.textContent = title; 
    toastElement.append(titleElement);

    messages.forEach(message => {
      const messageElement = document.createElement('span')
      messageElement.textContent = message;
      toastElement.append(messageElement)
    });

    toastElement.addEventListener('click', () => toastElement.remove());

    toasts.append(toastElement);
    setTimeout(() => toastElement.remove(), 3000)
  }

  const path = window.location.pathname;
  if (path.match('^/admin/experiments/?$')) {
    experimentsPage(createToast);
  } else if (path.match('^/admin/device_tokens/?$')) {
    deviceTokensPage(createToast);
  }
});
