# Тестовое задание: АБ-тест

## Подготовка

**1. Установить ruby версии 3.2.1**

**2. Установить Postgres**

**3. Создать базы данных**
```
$ psql

# CREATE DATABASE ab_test_development;
# CREATE DATABASE ab_test_test;
```

## Установка

**1. Установить gems:**
```
bundle install
```

**2. Произвести миграции и загрузить тестовые данные:**

Если необходимо, то настройка подключения к БД задаётся переменными
```
DB_PORT: по-умолчани 5432
DB_HOST: по-молчанию localhost
DB_USERNAME: по-умолчанию ''
DB_PASSWORD: по-умолчанию ''
```
см. файл config/database.yml

```
DB_HOST=%host% DB_PORT=%port% DB_USERNAME=%username% DB_PASSWORD=%password% rails db:reset
```

**3. Запустить веб-приложение:**
```
DB_HOST=%host% DB_PORT=%port% DB_USERNAME=%username% DB_PASSWORD=%password% rails s
```

## API

### Список экспериментов

**Запрос**

*GET /api/v1/devices/experiments*

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

## Страницы

**Статистика по экcпериментам**

URL: */admin/experiments*

**Токены**

URL: */admin/device_tokens*


### Пример страницы

![страница "Эксперименты"](https://cdn.test-bench.ru/cdn/ab-test-example-experiments-02.png)
