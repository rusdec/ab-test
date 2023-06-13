# Тестовое задание: АБ-тест

## Установка

Произвести миграции:
```
rails db:setup
```

Загрузить тестовые данные:
```
rails db:seed
```

Запустить веб-приложение:
```
rails -s
```

## API

### Список экспериментов

**Запрос**

URL: *GET /api/v1/devices/experiments*

Данные: *заголовок Device-Token*

**Ответ**
```
{ string: string }
```

**Пример**
```
{
  "button_color": "#00FF00",
  "price": "10"
}
```

### Страницы

**Статистика по экcпериментам**

URL: */admin/experiments*

**Токены**

URL: */admin/device_tokens*
