# CVortex HR Platform Frontend

Веб-интерфейс для платформы автоматизации HR-процессов с AI-скринингом резюме и оценкой интервью.

## Возможности

- **Управление вакансиями** — создание и редактирование вакансий с требованиями к кандидатам
- **Список кандидатов** — просмотр и фильтрация кандидатов по статусам
- **Массовый скрининг** — загрузка резюме для автоматического AI-анализа
- **Авторизация** — аутентификация через Yandex OAuth

## Технологии

- **React 18** — UI библиотека
- **TypeScript** — типизация
- **Vite 5** — сборка и dev-сервер
- **Material UI v5** — компоненты интерфейса
- **react-router-dom v6** — маршрутизация

## Требования

- Node.js 20+
- npm 9+

## Установка

```bash
npm install
```

## Конфигурация

Создайте файл `.env` в корне проекта:

```env
VITE_BACKEND_BASE_URL=https://api.example.com
VITE_TG_URL=https://t.me/your_bot
```

| Переменная | Описание |
|------------|----------|
| `VITE_BACKEND_BASE_URL` | URL backend API |
| `VITE_TG_URL` | Ссылка на Telegram бота |

## Команды

```bash
# Запуск dev-сервера (порт 3000)
npm run dev

# Сборка для production
npm run build

# Просмотр production сборки
npm run preview

# Линтинг
npm run lint
```

## Структура проекта

```
src/
├── components/          # Общие компоненты
│   ├── Layout.tsx       # Основной layout с навигацией
│   └── ProtectedRoute.tsx   # Защита маршрутов
├── pages/               # Страницы
│   ├── Login.tsx        # Авторизация
│   ├── CandidatesList.tsx   # Список кандидатов
│   ├── VacanciesList.tsx    # Список вакансий
│   ├── CreateVacancy.tsx    # Создание вакансии
│   └── MassScreening.tsx    # Массовый скрининг
├── services/
│   └── api.ts           # API клиент
└── types/
    └── index.ts         # TypeScript типы
```

## API Endpoints

| Endpoint | Описание |
|----------|----------|
| `/auth/login` | Авторизация |
| `/api/v1/vacancies` | CRUD вакансий |
| `/api/v1/candidates` | CRUD кандидатов |
| `/api/bot/v1/*` | Интеграция с Telegram ботом |

## Docker

```bash
# Сборка образа
docker build \
  --build-arg VITE_BACKEND_BASE_URL=https://api.example.com \
  --build-arg VITE_TG_URL=https://t.me/your_bot \
  -t hr-platform-frontend .

# Запуск контейнера
docker run -p 80:80 hr-platform-frontend
```

## Разработка

### Стиль кода

- ESLint с TypeScript правилами
- Материалы и тексты на русском языке
- Комментарии на английском языке

### Тема оформления

- Основной цвет: `#0088CC`
- Скругление углов: 12-16px
- Шрифт: Roboto

## Лицензия

Private project
