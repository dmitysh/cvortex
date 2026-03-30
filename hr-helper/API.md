# HR Helper API Documentation

## Overview

HR Helper provides a REST API for HR recruitment automation with AI-powered
resume screening and interview evaluation. The API is organized into two groups:

- **Bot API** (`/api/bot/v1/*`) - endpoints for Telegram bot interactions
- **HR API** (`/api/v1/*`) - endpoints for HR frontend
- **Private API** (`/api/_private/v1/*`) - internal administrative endpoints

**Base URL**: `http://localhost:8080` (local development)

---

## Authentication

Authentication is handled via Yandex OAuth 2.0 with JWT tokens stored in
HTTP-only cookies.

### Response Format

All endpoints return JSON with `Content-Type: application/json`.

**Success Response:**
```json
{
  "id": "created_resource_id"
}
```

**Error Response:**
```json
{
  "error": "error description"
}
```

---

## Bot API Endpoints

### Create Candidate

Creates a new candidate record linked to Telegram account.

```
POST /api/bot/v1/candidate
```

**Request Body:**
```json
{
  "telegram_id": 123456789,
  "telegram_username": "johndoe",
  "full_name": "John Doe",
  "phone": "+79001234567",
  "city": "Moscow"
}
```

**Response:** `201 Created`
```json
{
  "id": 1
}
```

---

### Get Candidate by Telegram ID

Retrieves candidate information by their Telegram ID.

```
GET /api/bot/v1/candidates/by-tg-id/{telegram-id}
```

**Path Parameters:**
- `telegram-id` (int64) - Telegram user ID

**Response:** `200 OK`
```json
{
  "id": 1,
  "telegram_id": 123456789,
  "telegram_username": "johndoe",
  "full_name": "John Doe",
  "phone": "+79001234567",
  "city": "Moscow",
  "created_at": "2024-01-15T10:30:00Z"
}
```

**Errors:**
- `404 Not Found` - candidate not found

---

### Process Resume Screening

Triggers AI-powered resume screening for a candidate against a vacancy.

```
POST /api/bot/v1/screening/process
```

**Request Body:**
```json
{
  "candidate_id": 1,
  "vacancy_id": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Response:** `200 OK`

**Errors:**
- `404 Not Found` - candidate or vacancy not found

---

### Get Questions by Vacancy ID

Retrieves all interview questions for a specific vacancy.

```
GET /api/bot/v1/questions/{vacancy-id}
```

**Path Parameters:**
- `vacancy-id` (UUID) - Vacancy identifier

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "vacancy_id": "550e8400-e29b-41d4-a716-446655440000",
    "content": "Tell us about your experience with Go",
    "reference": "Expected answer covering Go concurrency patterns",
    "time_limit": 120,
    "position": 1,
    "created_at": "2024-01-15T10:30:00Z"
  }
]
```

---

### Create Answer

Submits a candidate's answer to an interview question.

```
POST /api/bot/v1/answer
```

**Request Body:**
```json
{
  "candidate_id": 1,
  "question_id": 1,
  "content": "I have 3 years of experience with Go...",
  "time_taken": 45
}
```

**Response:** `201 Created`
```json
{
  "id": 1
}
```

---

### Process Interview Scoring

Triggers AI-powered scoring of all candidate answers for an interview.

```
POST /api/bot/v1/interview/process
```

**Request Body:**
```json
{
  "candidate_id": 1,
  "vacancy_id": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Response:** `200 OK`

**Errors:**
- `404 Not Found` - candidate or vacancy not found

---

### Get Meta

Retrieves the meta information (status and scores) for a
candidate-vacancy pair.

```
GET /api/bot/v1/meta/{candidate-id}/{vacancy-id}
```

**Path Parameters:**
- `candidate-id` (int64) - Candidate identifier
- `vacancy-id` (UUID) - Vacancy identifier

**Response:** `200 OK`
```json
{
  "candidate_id": 1,
  "vacancy_id": "550e8400-e29b-41d4-a716-446655440000",
  "interview_score": 85,
  "status": "screening_ok",
  "is_archived": false,
  "updated_at": "2024-01-15T10:30:00Z"
}
```

**Possible Status Values:**
- `screening_ok` - passed resume screening
- `screening_failed` - failed resume screening
- `interview_ok` - passed interview
- `interview_failed` - failed interview

---

## HR API Endpoints

### Authentication

#### Login

Initiates OAuth login flow with specified provider.

```
GET /api/v1/login?provider={provider}
```

**Query Parameters:**
- `provider` (string) - OAuth provider (`yandex` or `demo`)

**Response:** `302 Found` - Redirects to OAuth provider

---

#### Auth Callback

Handles OAuth callback and sets JWT cookie.

```
GET /api/v1/auth?provider={provider}&code={code}
```

**Query Parameters:**
- `provider` (string) - OAuth provider (`yandex` or `demo`)
- `code` (string) - OAuth authorization code (for Yandex)

**Response:** `302 Found` - Redirects to frontend URL

**Cookie Set:**
- `jwt_token` - HTTP-only, Secure, MaxAge: 3600

---

#### Logout

Clears authentication cookie.

```
GET /api/v1/logout
```

**Response:** `302 Found` - Redirects to `/login`

---

### Vacancies

#### Create Vacancy

Creates a new job vacancy with interview questions.

```
POST /api/v1/vacancy
```

**Request Body:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "title": "Senior Go Developer",
  "key_requirements": [
    "5+ years Go experience",
    "Microservices architecture",
    "PostgreSQL"
  ],
  "questions": [
    {
      "content": "Explain Go concurrency model",
      "reference": "goroutines, channels, select",
      "time_limit": 120
    }
  ]
}
```

**Response:** `201 Created`
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000"
}
```

---

#### Get All Vacancies

Retrieves all vacancies with their questions.

```
GET /api/v1/vacancies
```

**Response:** `200 OK`
```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "title": "Senior Go Developer",
    "key_requirements": ["5+ years Go experience"],
    "questions": [
      {
        "id": 1,
        "vacancy_id": "550e8400-e29b-41d4-a716-446655440000",
        "content": "Explain Go concurrency model",
        "reference": "goroutines, channels, select",
        "time_limit": 120,
        "position": 1,
        "created_at": "2024-01-15T10:30:00Z"
      }
    ],
    "created_at": "2024-01-15T10:30:00Z"
  }
]
```

---

#### Get Vacancy by ID

Retrieves a specific vacancy with all questions.

```
GET /api/v1/vacancy/{vacancy-id}
```

**Path Parameters:**
- `vacancy-id` (UUID) - Vacancy identifier

**Response:** `200 OK`
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "title": "Senior Go Developer",
  "key_requirements": ["5+ years Go experience"],
  "questions": [...],
  "created_at": "2024-01-15T10:30:00Z"
}
```

**Errors:**
- `404 Not Found` - vacancy not found

---

#### Delete Vacancy

Deletes a vacancy by ID.

```
DELETE /api/v1/vacancy/{vacancy-id}
```

**Path Parameters:**
- `vacancy-id` (UUID) - Vacancy identifier

**Response:** `200 OK`

---

#### Archive Vacancy for Candidate

Archives a candidate-vacancy relationship.

```
POST /api/v1/vacancy/archive
```

**Request Body:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "candidate_id": 1
}
```

**Response:** `200 OK`

---

### Candidate Information

#### Get All Candidate-Vacancy Infos

Retrieves summary information for all candidate-vacancy pairs.

```
GET /api/v1/candidate-vacancy-infos
```

**Response:** `200 OK`
```json
[
  {
    "candidate": {
      "id": 1,
      "telegram_id": 123456789,
      "telegram_username": "johndoe",
      "full_name": "John Doe",
      "phone": "+79001234567",
      "city": "Moscow",
      "created_at": "2024-01-15T10:30:00Z"
    },
    "vacancy": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "title": "Senior Go Developer",
      "key_requirements": ["5+ years Go experience"],
      "created_at": "2024-01-15T10:30:00Z"
    },
    "meta": {
      "candidate_id": 1,
      "vacancy_id": "550e8400-e29b-41d4-a716-446655440000",
      "interview_score": 85,
      "status": "interview_ok",
      "is_archived": false,
      "updated_at": "2024-01-15T10:30:00Z"
    },
    "resume_screening": {
      "id": 1,
      "candidate_id": 1,
      "vacancy_id": "550e8400-e29b-41d4-a716-446655440000",
      "score": 75,
      "feedback": "Strong technical background",
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z"
    },
    "resume_link": "https://s3.example.com/resumes/123.pdf"
  }
]
```

---

#### Get Candidate-Vacancy Info

Retrieves detailed information for a specific candidate-vacancy pair.

```
GET /api/v1/candidate-vacancy-info/{candidate-id}/{vacancy-id}
```

**Path Parameters:**
- `candidate-id` (int64) - Candidate identifier
- `vacancy-id` (UUID) - Vacancy identifier

**Response:** `200 OK` - Single `GetCandidateVacancyInfoResponse` object

**Errors:**
- `404 Not Found` - not found

---

#### Get Screening Result

Retrieves AI-generated resume screening result.

```
GET /api/v1/screening/result/{candidate-id}/{vacancy-id}
```

**Path Parameters:**
- `candidate-id` (int64) - Candidate identifier
- `vacancy-id` (UUID) - Vacancy identifier

**Response:** `200 OK`
```json
{
  "id": 1,
  "candidate_id": 1,
  "vacancy_id": "550e8400-e29b-41d4-a716-446655440000",
  "score": 75,
  "feedback": "Strong technical background with relevant experience",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z"
}
```

**Errors:**
- `404 Not Found` - screening result not found

---

#### Get Candidate Answers

Retrieves all answers submitted by a candidate for a specific vacancy.

```
GET /api/v1/candidate/answers/{candidate-id}/{vacancy-id}
```

**Path Parameters:**
- `candidate-id` (int64) - Candidate identifier
- `vacancy-id` (UUID) - Vacancy identifier

**Response:** `200 OK`
```json
[
  {
    "question": {
      "id": 1,
      "vacancy_id": "550e8400-e29b-41d4-a716-446655440000",
      "content": "Explain Go concurrency model",
      "reference": "goroutines, channels, select",
      "time_limit": 120,
      "position": 1,
      "created_at": "2024-01-15T10:30:00Z"
    },
    "answer": {
      "id": 1,
      "candidate_id": 1,
      "question_id": 1,
      "content": "Go uses goroutines for lightweight threads...",
      "score": 90,
      "time_taken": 45,
      "created_at": "2024-01-15T10:30:00Z"
    }
  }
]
```

**Errors:**
- `404 Not Found` - answers not found

---

#### Get Upload URL

Generates a presigned URL for uploading a resume file directly to S3.

```
POST /api/v1/candidates/upload-url
```

**Request Body:**
```json
{
  "candidate_id": 1,
  "vacancy_id": "550e8400-e29b-41d4-a716-446655440000",
  "filename": "resume.pdf"
}
```

**Response:** `200 OK`
```json
{
  "upload_url": "https://storage.yandexcloud.net/hr-helper-resume/1/550e8400-e29b-41d4-a716-446655440000/resume.pdf?X-Amz-...",
  "file_key": "1/550e8400-e29b-41d4-a716-446655440000/resume.pdf",
  "expires_in": 600
}
```

**Fields:**
- `upload_url` - Presigned URL for PUT request to S3
- `file_key` - Object key in S3 bucket
- `expires_in` - URL expiration time in seconds (10 minutes)

**Usage:**
```bash
# 1. Get presigned URL
curl -X POST http://localhost:8080/api/v1/candidates/upload-url \
  -H "Content-Type: application/json" \
  -d '{"candidate_id":1,"vacancy_id":"550e8400-e29b-41d4-a716-446655440000","filename":"resume.pdf"}'

# 2. Upload file directly to S3
curl -X PUT -T resume.pdf "<upload_url from response>"
```

**Errors:**
- `400 Bad Request` - invalid JSON or missing filename
- `500 Internal Server Error` - failed to generate upload URL

---

## Private API Endpoints

### Delete Candidate

Permanently deletes a candidate record.

```
DELETE /api/_private/v1/candidate/{candidate-id}
```

**Path Parameters:**
- `candidate-id` (int64) - Candidate identifier

**Response:** `200 OK`

---

## Data Types

### UUID

All IDs for vacancies are UUID v4 strings:
```
550e8400-e29b-41d4-a716-446655440000
```

### Timestamps

All timestamps are in RFC3339 format (ISO 8601):
```
2024-01-15T10:30:00Z
```

### Score Values

- Resume screening score: 0-100
- Interview score: 0-100

### Meta Status Values

| Status | Description |
|--------|-------------|
| `screening_ok` | Candidate passed resume screening |
| `screening_failed` | Candidate failed resume screening |
| `interview_ok` | Candidate passed interview |
| `interview_failed` | Candidate failed interview |

---

## HTTP Status Codes

| Code | Description |
|------|-------------|
| 200 | Success |
| 201 | Created |
| 302 | Redirect |
| 400 | Bad Request - invalid JSON or parameters |
| 404 | Not Found |
| 500 | Internal Server Error |

---

## CORS Configuration

The API supports CORS with the following settings:

- **Allowed Origins**: `*` (all origins)
- **Allowed Methods**: `GET`, `POST`, `PUT`, `DELETE`, `OPTIONS`
- **Allowed Headers**: `Accept`, `Authorization`, `Content-Type`, `X-CSRF-Token`
- **Credentials**: Enabled
- **Max Age**: 300 seconds
