# Тестовое задание: АБ-тест

## Запуск приложения

**1. Создать файл .env в корне проекта**
```
echo 'POSTGRES_USER=postgres' >> .env
echo 'POSTGRES_PASSWORD=postgres' >> .env
echo 'POSTGRES_PORT=5432' >> .env
echo 'POSTGRES_HOST=db' >> .env
echo 'RAILS_ENV=development' >> .env
```

**2. Запустить контейнер приложения и контейнер БД**

```
docker-compose up -d
```

**3. Создать базы данных в контейнере БД**
```
docker-compose exec db psql -U postgres -h db -W -c 'create database ab_test_development'
docker-compose exec db psql -U postgres -h db -W -c 'create database ab_test_production'
docker-compose exec db psql -U postgres -h db -W -c 'create database ab_test_test'
```

**4. Перезапустить контейнер приложения**
```
docker-compose restart web
```

**5. Произвести загрузку демо-данных**

```
docker-compose exec web bundle exec rake db:seed
```

**6. Открыть адрес в браузере**

```
http://localhost:3000
```
---

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
---

## Страницы

**Статистика по экcпериментам**

URL: */admin/experiments*

**Токены**

URL: */admin/device_tokens*

---

## Тесты

**1. Произвести миграции**

```
docker-compose exec web bundle exec rake db:test:prepare
```

**2. Запустить тесты**

- общие тесты: `docker-compose exec -e "RAILS_ENV=test" web rspec`
- тесты производительности: `docker-compose exec -e "RAILS_ENV=test" web rspec --tag slow_benchmark`

---

## Документация

В каталоге ![web/docs](/web/docs) есть следующие drawio-схемы:

- ![Схема связей в таблице](/web/docs/table-schema.drawio)
- ![Схема обработки запроса](/web/docs/handle-request-schema.drawio)

---

## Пример страницы

![страница "Эксперименты"](https://cdn.test-bench.ru/cdn/ab-test-example-experiments-04.png)
