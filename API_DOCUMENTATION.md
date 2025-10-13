# API Documentation

## Base URL
```
http://localhost:5001/api
```

## Authentication

All protected endpoints require a valid JWT token in the Authorization header or as a cookie.

### Headers
```
Authorization: Bearer <access_token>
```

### Cookies
```
accessToken: <access_token>
refreshToken: <refresh_token>
```

## Endpoints

### Authentication

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "userid": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "accessToken": "string",
  "refreshToken": "string",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

#### Logout
```http
POST /api/auth/logout
```

**Response:**
```json
{
  "message": "Logged out successfully"
}
```

#### Refresh Token
```http
POST /api/auth/refresh
```

**Response:**
```json
{
  "accessToken": "string",
  "refreshToken": "string"
}
```

#### Request Password Reset
```http
POST /api/auth/request-password-reset
Content-Type: application/json

{
  "userid": "string"
}
```

**Response:**
```json
{
  "message": "Password reset email sent"
}
```

#### Reset Password
```http
POST /api/auth/reset-password/:token
Content-Type: application/json

{
  "password": "string"
}
```

**Response:**
```json
{
  "message": "Password reset successfully"
}
```

### User Management

#### Get Current User
```http
GET /api/user/me
Authorization: Bearer <token>
```

**Response:**
```json
{
  "id": 1,
  "fname": "John",
  "lname": "Doe",
  "email": "john@example.com",
  "userid": "john.doe",
  "designation": "Developer",
  "mobileno": "1234567890",
  "roles": ["admin", "user"],
  "department": "IT"
}
```

#### Get User Profile
```http
GET /api/user/profile
Authorization: Bearer <token>
```

**Response:**
```json
{
  "id": 1,
  "fname": "John",
  "lname": "Doe",
  "email": "john@example.com",
  "userid": "john.doe",
  "designation": "Developer",
  "mobileno": "1234567890",
  "birthDate": "1990-01-01",
  "bloodGroup": "O+",
  "profilePhoto": "/profile/photo.jpg",
  "roles": ["admin", "user"],
  "department": "IT"
}
```

#### Update Profile
```http
PUT /api/user/profile
Authorization: Bearer <token>
Content-Type: application/json

{
  "fname": "John",
  "lname": "Doe",
  "email": "john@example.com",
  "designation": "Senior Developer",
  "mobileno": "1234567890",
  "birthDate": "1990-01-01",
  "bloodGroup": "O+"
}
```

**Response:**
```json
{
  "message": "Profile updated successfully",
  "user": { ... }
}
```

#### Upload Profile Photo
```http
POST /api/user/profile/photo
Authorization: Bearer <token>
Content-Type: multipart/form-data

profilePhoto: <file>
```

**Response:**
```json
{
  "message": "Profile photo uploaded successfully",
  "profilePhoto": "/profile/photo.jpg"
}
```

#### Update Password
```http
PUT /api/user/password
Authorization: Bearer <token>
Content-Type: application/json

{
  "oldPassword": "string",
  "newPassword": "string"
}
```

**Response:**
```json
{
  "message": "Password updated successfully"
}
```

#### Get User Statistics (Admin Only)
```http
GET /api/user/stats
Authorization: Bearer <token>
```

**Response:**
```json
{
  "total": 100,
  "active": 95,
  "new": 5,
  "inactive": 5,
  "analytic": {
    "totalChange": 2.5,
    "activeChange": 10.6,
    "newChange": 6.5,
    "inactiveChange": 6.9
  }
}
```

#### List Users (Admin Only)
```http
GET /api/user
Authorization: Bearer <token>
```

**Query Parameters:**
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 10)
- `isActive`: Filter by active status
- `roles`: Filter by roles (comma-separated)
- `department`: Filter by department

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "fname": "John",
      "lname": "Doe",
      "email": "john@example.com",
      "userid": "john.doe",
      "designation": "Developer",
      "mobileno": "1234567890",
      "isApproved": true,
      "isActive": true,
      "profilePhoto": "/profile/photo.jpg",
      "lastLogin": "2024-01-01T10:00:00Z",
      "roles": "admin, user",
      "department": "IT"
    }
  ]
}
```

#### Get User by ID (Admin Only)
```http
GET /api/user/:id
Authorization: Bearer <token>
```

**Response:**
```json
{
  "data": {
    "id": 1,
    "fname": "John",
    "lname": "Doe",
    "email": "john@example.com",
    "userid": "john.doe",
    "designation": "Developer",
    "mobileno": "1234567890",
    "isApproved": true,
    "isActive": true,
    "profilePhoto": "/profile/photo.jpg",
    "lastLogin": "2024-01-01T10:00:00Z",
    "roles": [1, 2],
    "department": 1
  }
}
```

#### Create User (Admin Only)
```http
POST /api/user
Authorization: Bearer <token>
Content-Type: application/json

{
  "fname": "John",
  "lname": "Doe",
  "email": "john@example.com",
  "userid": "john.doe",
  "password": "password123",
  "designation": "Developer",
  "mobileno": "1234567890",
  "roleNames": "[1, 2]",
  "department": 1,
  "bloodGroup": "O+",
  "birthDate": "1990-01-01"
}
```

**Response:**
```json
{
  "message": "User created successfully"
}
```

#### Update User (Admin Only)
```http
PUT /api/user/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "fname": "John",
  "lname": "Doe",
  "email": "john@example.com",
  "designation": "Senior Developer",
  "mobileno": "1234567890",
  "roleNames": "[1, 2]",
  "department": 1,
  "bloodGroup": "O+",
  "birthDate": "1990-01-01"
}
```

**Response:**
```json
{
  "message": "User updated successfully",
  "user": { ... }
}
```

#### Delete User (Admin Only)
```http
DELETE /api/user/:id
Authorization: Bearer <token>
```

**Response:**
```json
{
  "message": "User deleted successfully"
}
```

#### Approve User (Admin Only)
```http
PUT /api/user/:id/approve
Authorization: Bearer <token>
```

**Response:**
```json
{
  "message": "User approved"
}
```

#### Change User Status (Admin Only)
```http
PUT /api/user/:id/status
Authorization: Bearer <token>
Content-Type: application/json

{
  "status": true
}
```

**Response:**
```json
{
  "message": "User activated"
}
```

## Error Responses

### 400 Bad Request
```json
{
  "success": false,
  "message": "Validation Error",
  "details": ["Name is required", "Email is invalid"]
}
```

### 401 Unauthorized
```json
{
  "success": false,
  "message": "User Unauthorized"
}
```

### 403 Forbidden
```json
{
  "success": false,
  "message": "Permission Denied"
}
```

### 404 Not Found
```json
{
  "success": false,
  "message": "Not Found - /api/invalid-endpoint"
}
```

### 500 Internal Server Error
```json
{
  "success": false,
  "message": "Internal Server Error",
  "error": "Detailed error information (development only)"
}
```

## File Upload

### Supported File Types
- **Images**: JPEG, PNG, GIF
- **Documents**: PDF, DOC, DOCX
- **Maximum Size**: 50MB

### Upload Endpoints
- **Profile Photos**: `/api/user/profile/photo`
- **Documents**: `/api/documents/upload`

### Upload Format
```http
POST /api/upload
Content-Type: multipart/form-data

file: <file>
```

## Pagination

### Query Parameters
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 10, max: 100)

### Response Format
```json
{
  "data": [...],
  "pagination": {
    "currentPage": 1,
    "totalPages": 10,
    "totalItems": 100,
    "itemsPerPage": 10,
    "hasNextPage": true,
    "hasPrevPage": false,
    "nextPage": 2,
    "prevPage": null
  }
}
```

## Rate Limiting

- **Limit**: 100 requests per 15 minutes per IP
- **Headers**: Rate limit information in response headers
- **Exceeded**: 429 Too Many Requests

## CORS

- **Origins**: Configurable via environment variables
- **Methods**: GET, POST, PUT, DELETE, OPTIONS, PATCH
- **Headers**: Content-Type, Authorization, Cookie
- **Credentials**: Supported

## Webhooks

### Available Events
- `user.created`: User created
- `user.updated`: User updated
- `user.deleted`: User deleted
- `user.approved`: User approved

### Webhook Format
```json
{
  "event": "user.created",
  "data": {
    "id": 1,
    "email": "john@example.com",
    "createdAt": "2024-01-01T10:00:00Z"
  },
  "timestamp": "2024-01-01T10:00:00Z"
}
```

## SDK Examples

### JavaScript/Node.js
```javascript
const axios = require('axios');

const api = axios.create({
  baseURL: 'http://localhost:5001/api',
  headers: {
    'Authorization': 'Bearer <token>'
  }
});

// Get current user
const user = await api.get('/user/me');

// Create user
const newUser = await api.post('/user', {
  fname: 'John',
  lname: 'Doe',
  email: 'john@example.com',
  userid: 'john.doe',
  password: 'password123'
});
```

### Python
```python
import requests

headers = {
    'Authorization': 'Bearer <token>',
    'Content-Type': 'application/json'
}

# Get current user
response = requests.get('http://localhost:5001/api/user/me', headers=headers)
user = response.json()

# Create user
data = {
    'fname': 'John',
    'lname': 'Doe',
    'email': 'john@example.com',
    'userid': 'john.doe',
    'password': 'password123'
}
response = requests.post('http://localhost:5001/api/user', json=data, headers=headers)
```

### cURL Examples
```bash
# Login
curl -X POST http://localhost:5001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"userid": "john.doe", "password": "password123"}'

# Get current user
curl -X GET http://localhost:5001/api/user/me \
  -H "Authorization: Bearer <token>"

# Create user
curl -X POST http://localhost:5001/api/user \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"fname": "John", "lname": "Doe", "email": "john@example.com"}'
```
