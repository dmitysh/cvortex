# HR Bot

Telegram-бот для автоматизации HR-рекрутинга. Предоставляет кандидатам интерфейс для регистрации, загрузки резюме и прохождения автоматизированных интервью.

## Возможности

- Регистрация кандидата через FSM (Finite State Machine)
- Загрузка и валидация резюме (PDF, до 5 МБ)
- Хранение резюме в Yandex Object Storage
- Автоматическое интервью с вопросами от HR
- Интеграция с Go-бэкендом для AI-скоринга

## Технологии

- **Python 3.x** - язык программирования
- **Aiogram 3.x** - асинхронный фреймворк для Telegram Bot API
- **aiohttp** - HTTP-клиент для API-запросов
- **boto3** - работа с Yandex Object Storage (S3-совместимое API)
- **python-dotenv** - управление переменными окружения

## Структура проекта

```
hr-bot/
├── main.py             # Точка входа, инициализация бота
├── handlers.py         # Обработчики команд и callback-запросов
├── states.py           # Определение FSM-состояний
├── config.py           # Конфигурация из переменных окружения
├── backend_client.py   # HTTP-клиент для Go API
├── s3_service.py       # Интеграция с Yandex Object Storage
├── keyboards.py        # Построители inline-клавиатур
├── util.py             # Утилиты (валидация телефона и др.)
├── requirements.txt    # Зависимости Python
├── Dockerfile          # Docker-образ
└── .env                # Переменные окружения (не в git)
```

## Установка

### Локальный запуск

1. Установите зависимости:
   ```bash
   pip install -r requirements.txt
   ```

2. Создайте файл `.env` с переменными окружения:
   ```env
   BOT_TOKEN=your_telegram_bot_token
   BACKEND_BASE_URL=http://localhost:8080
   YC_ACCESS_KEY_ID=your_yandex_access_key
   YC_SECRET_ACCESS_KEY=your_yandex_secret_key
   YC_BUCKET_NAME=your_bucket_name
   YC_ENDPOINT_URL=https://storage.yandexcloud.net
   ADMIN_ID=your_telegram_id
   ```

3. Запустите бота:
   ```bash
   python main.py
   ```

### Docker

```bash
docker build -t hr-bot .
docker run --env-file .env hr-bot
```

## Команды бота

| Команда | Описание |
|---------|----------|
| `/resume` | Продолжить регистрацию или интервью |
| `/questions` | Часто задаваемые вопросы |

## FSM-состояния

### Регистрация кандидата
```
waiting_for_vacancy
       ↓
waiting_for_name
       ↓
waiting_for_phone
       ↓
waiting_for_telegram_username
       ↓
waiting_for_city
       ↓
waiting_for_resume
```

### Прохождение интервью
```
waiting_for_start
       ↓
answering_question
       ↓
interview_completed / passed / rejected
```

## API бэкенда

Бот взаимодействует с Go-бэкендом через эндпоинты `/api/bot/v1/*`:

| Метод | Эндпоинт | Описание |
|-------|----------|----------|
| POST | `/candidate` | Создание кандидата |
| GET | `/candidates/by-tg-id/{id}` | Получение кандидата по Telegram ID |
| POST | `/screening/process` | Обработка скрининга резюме |
| GET | `/questions/{vacancy-id}` | Получение вопросов для интервью |
| POST | `/answer` | Отправка ответа на вопрос |
| POST | `/interview/process` | Завершение интервью |
| GET | `/meta/{candidate-id}/{vacancy-id}` | Получение статуса скрининга |

## Конфигурация

| Переменная | Описание | Обязательно |
|------------|----------|-------------|
| `BOT_TOKEN` | Токен Telegram-бота от BotFather | Да |
| `BACKEND_BASE_URL` | URL Go-бэкенда | Нет (default: `http://localhost:8080`) |
| `YC_ACCESS_KEY_ID` | Yandex Cloud access key | Да |
| `YC_SECRET_ACCESS_KEY` | Yandex Cloud secret key | Да |
| `YC_BUCKET_NAME` | Название S3-бакета для резюме | Да |
| `YC_ENDPOINT_URL` | Endpoint Yandex Object Storage | Да |
| `ADMIN_ID` | Telegram ID администратора | Нет |

## Связанные сервисы

- **hr-helper** - Go REST API бэкенд (`../hr-helper/`)
- **web-app** - React-фронтенд для HR-менеджеров (`../web-app/`)

## Лицензия

Proprietary
