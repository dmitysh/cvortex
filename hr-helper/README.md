# HR Helper

Go REST API backend for HR recruitment automation with AI-powered resume screening
and interview evaluation. Part of the [CVortex (kekly.ru)](../) platform.

## Overview

HR Helper provides the core API services for:
- Resume screening using Yandex GPT AI
- Interview scoring and evaluation
- Vacancy and question management
- Candidate data management
- Yandex OAuth 2.0 authentication

## Architecture

```
cmd/hr-helper/main.go              # Entry point
internal/
├── handler/httpapi/               # HTTP handlers (chi router)
├── service/                       # Business logic
│   ├── candidate/                 # Candidate & resume scoring
│   ├── vacancy/                   # Vacancy & interview scoring
│   └── auther/                    # JWT authentication
├── adapter/                       # External integrations
│   ├── repository/                # PostgreSQL (pgx)
│   ├── llm/                       # Yandex GPT API
│   └── objstorage/                # S3 resume storage (minio)
├── entity/                        # Domain models
├── dto_models/                    # Request/response DTOs
├── service_models/                # Internal service models
└── pkg/houston/                   # Shared utilities
```

## API Endpoints

### Bot API (`/api/bot/v1/*`)
Endpoints for Telegram bot:
- `POST /candidate` - Create candidate
- `GET /candidates/by-tg-id/{id}` - Get by Telegram ID
- `POST /screening/process` - Trigger resume screening
- `GET /questions/{vacancy-id}` - Get interview questions
- `POST /answer` - Submit answer
- `POST /interview/process` - Score interview
- `GET /meta/{candidate-id}/{vacancy-id}` - Get status/scores

### HR API (`/api/v1/*`)
Endpoints for HR frontend:
- `GET /login`, `/auth`, `/logout` - OAuth authentication
- `POST /vacancy`, `GET /vacancies`, `DELETE /vacancy/{id}` - Vacancy CRUD
- `GET /candidate-vacancy-infos` - List all candidate info
- `GET /screening/result/{candidate-id}/{vacancy-id}` - Screening results
- `GET /candidate/answers/{candidate-id}/{vacancy-id}` - Interview answers
- `POST /candidates/upload-url` - Presigned S3 upload URL

Full documentation: [API.md](./API.md)

## Tech Stack

- **Go 1.25** - Runtime
- **go-chi/chi** - HTTP router
- **pgx** - PostgreSQL driver
- **minio-go** - S3 client
- **viper** - Configuration
- **zap** - Logging
- **goose** - Migrations

## Requirements

- Go 1.25+
- PostgreSQL 14+
- Access to Yandex Cloud services (S3, Yandex GPT)

## Configuration

Configuration loaded from `configs/values-prod.yaml`. Secrets from environment:

| Variable | Description |
|----------|-------------|
| `POSTGRES_USER` | Database username |
| `POSTGRES_PASSWORD` | Database password |
| `JWT_SECRET` | JWT signing key |
| `YANDEX_OAUTH_CLIENT_ID` | OAuth client ID |
| `YANDEX_OAUTH_CLIENT_SECRET` | OAuth secret |
| `YANDEX_LLM_API_KEY` | Yandex GPT API key |
| `YANDEX_FOLDER_ID` | Yandex Cloud folder ID |
| `S3_ACCESS_KEY` | S3 access key |
| `S3_SECRET_KEY` | S3 secret key |

## Development

```bash
# Run locally
make run

# Run with Docker Compose
make up-dev

# Apply migrations
make migrate-up
```

## Deployment

```bash
make deploy
```

Deployment uses rsync over SSH to production server.

## Scoring Logic

- **Resume screening**: Score 0-100 via Yandex GPT, pass threshold: 75
- **Interview scoring**: Average of answer scores, pass threshold: 75
- Status flow: `new` → `screening_ok/failed` → `interview_ok/failed`

## Related Services

- [hr-bot](../hr-bot) - Telegram bot for candidates
- [web-app](../web-app) - React frontend for HR managers
- [nginx](../nginx) - Gateway with JWT validation
