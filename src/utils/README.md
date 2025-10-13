# Utils Directory

This directory contains utility functions, helpers, and common functionality used throughout the application.

## Purpose

Utils provide reusable functionality for:
- Common operations
- Data formatting
- Validation helpers
- External service integrations
- Logging and monitoring

## Structure

```
utils/
├── logger/                     # Logging utilities
│   ├── logger.js              # Main logger
│   ├── metrics.js             # Prometheus metrics
│   └── typeorm.js             # TypeORM logger
├── database/                   # Database utilities
│   ├── getRepository.js       # Repository helper
│   └── transaction.js          # Transaction helper
├── token.js                    # JWT token utilities
├── mailer.js                   # Email utilities
├── paginate.js                 # Pagination utilities
├── validation.js               # Validation utilities
├── dateFormatter.js            # Date formatting
├── errorHandler.js             # Error handling utilities
└── pick.js                     # Object picking utilities
```

## Utility Guidelines

### 1. **Single Responsibility**
- Each utility should handle one specific task
- Keep functions focused and reusable
- Avoid complex dependencies

### 2. **Error Handling**
- Handle errors gracefully
- Provide meaningful error messages
- Log errors appropriately

### 3. **Performance**
- Optimize for performance
- Avoid unnecessary operations
- Use efficient algorithms

## Example Utility Structure

```javascript
// Example utility function
export const formatDate = (date, format = 'YYYY-MM-DD') => {
  try {
    if (!date) return null;
    return format(date, format);
  } catch (error) {
    console.error('Date formatting error:', error);
    return null;
  }
};

// Example utility class
export class EmailService {
  constructor() {
    this.transporter = nodemailer.createTransporter({
      // Email configuration
    });
  }

  async sendEmail(to, subject, content) {
    try {
      // Email sending logic
      return await this.transporter.sendMail({
        to,
        subject,
        html: content
      });
    } catch (error) {
      throw error;
    }
  }
}
```

## Common Utility Types

### 1. **Data Formatting**
```javascript
export const formatCurrency = (amount) => { /* Format currency */ };
export const formatDate = (date) => { /* Format date */ };
export const formatPhone = (phone) => { /* Format phone number */ };
```

### 2. **Validation Utilities**
```javascript
export const isValidEmail = (email) => { /* Email validation */ };
export const isValidPhone = (phone) => { /* Phone validation */ };
export const isValidPassword = (password) => { /* Password validation */ };
```

### 3. **String Utilities**
```javascript
export const slugify = (text) => { /* Create URL slug */ };
export const capitalize = (text) => { /* Capitalize text */ };
export const truncate = (text, length) => { /* Truncate text */ };
```

### 4. **Array Utilities**
```javascript
export const unique = (array) => { /* Remove duplicates */ };
export const groupBy = (array, key) => { /* Group by key */ };
export const sortBy = (array, key) => { /* Sort by key */ };
```

## File Naming Conventions

- Use camelCase for file names
- Use descriptive names
- End with `.js` extension
- Use consistent naming patterns

## Best Practices

1. **Reusability**: Make utilities reusable across the application
2. **Documentation**: Document complex utilities
3. **Testing**: Write tests for utilities
4. **Performance**: Optimize utility functions
5. **Error Handling**: Handle errors appropriately
6. **Consistency**: Use consistent patterns
7. **Simplicity**: Keep utilities simple and focused

## Common Utility Categories

### Logging Utilities
- Application logging
- Error logging
- Performance monitoring
- Metrics collection

### Database Utilities
- Repository helpers
- Transaction management
- Query builders
- Connection management

### Authentication Utilities
- JWT token handling
- Password hashing
- Session management
- Permission checking

### File Utilities
- File upload handling
- File processing
- File validation
- File storage

### Email Utilities
- Email sending
- Template processing
- Email validation
- Delivery tracking

### Data Utilities
- Data formatting
- Data validation
- Data transformation
- Data aggregation

## Utility Dependencies

Utilities typically depend on:
- External libraries
- Configuration settings
- Database connections
- Other utilities

## Error Handling

Utilities should handle errors by:
- Using try-catch blocks
- Providing fallback values
- Logging errors appropriately
- Returning consistent error formats

## Testing Utilities

Utilities should be tested with:
- Unit tests for individual functions
- Integration tests for complex utilities
- Performance tests for critical utilities
- Edge case testing
