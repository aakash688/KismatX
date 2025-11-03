# Test Suite Fixes Applied

## Issues Fixed

### 1. Login Field Name Mismatch
**Problem**: Tests were using `userid` but API expects `user_id` (with underscore)

**Fixed in**:
- ✅ `test_game_ui_apis.py` - Player login test
- ✅ `test_admin_panel_apis.py` - Admin login test

**Change**:
```python
# Before
{"userid": "player001", "password": "password123"}

# After
{"user_id": "player001", "password": "password123"}
```

### 2. Create User Field Names
**Problem**: Admin create user test used incorrect field names

**Fixed in**:
- ✅ `test_admin_panel_apis.py` - Create user test

**Changes**:
```python
# Before
{
    "userid": "...",
    "fname": "Test",
    "lname": "User",
    "mobileno": "...",
    "roleNames": ["Player"]
}

# After
{
    "user_id": "...",
    "first_name": "Test",
    "last_name": "User",
    "mobile": "...",
    "user_type": "player",
    "deposit_amount": 100,
    "roles": [player_role_id]  # Role IDs instead of names
}
```

### 3. Update User Field Names
**Problem**: Update user test used incorrect field names

**Fixed in**:
- ✅ `test_admin_panel_apis.py` - Update user test
- ✅ `test_game_ui_apis.py` - Update profile test

**Changes**:
```python
# Before
{"fname": "Test Updated", "lname": "User Updated"}

# After
{"first_name": "Test Updated", "last_name": "User Updated"}
```

### 4. Get All Users Response Structure
**Problem**: Test expected `data` field but API returns `users` field

**Fixed in**:
- ✅ `test_admin_panel_apis.py` - Get all users test

**Change**:
```python
# Before
users = data.get('data', [])

# After
users = data.get('users', data.get('data', []))
```

## Expected API Field Names

### Authentication
- ✅ `user_id` (not `userid`)
- ✅ `password`

### User Creation/Update
- ✅ `user_id` (not `userid`)
- ✅ `first_name` (not `fname`)
- ✅ `last_name` (not `lname`)
- ✅ `mobile` (not `mobileno`)
- ✅ `email`
- ✅ `password`
- ✅ `user_type` (player/admin/moderator)
- ✅ `deposit_amount` (for players)
- ✅ `roles` (array of role IDs, not role names)

### Profile Update
- ✅ `first_name`
- ✅ `last_name`
- ✅ `email`
- ✅ `mobile`
- ✅ `address`, `city`, `state`, `pin_code`, `region`

## Testing Status

After these fixes, the test suites should now:
- ✅ Successfully authenticate users
- ✅ Create users with correct field names
- ✅ Update users with correct field names
- ✅ Retrieve users correctly

## Running Tests

```bash
# Test Game UI APIs
python autotest/test_game_ui_apis.py

# Test Admin Panel APIs
python autotest/test_admin_panel_apis.py
```

---

**Fixed**: 2025-11-02  
**Issue**: Field name mismatches between test requests and API expectations




