# Entities Directory

This directory contains all database entities/models using TypeORM EntitySchema.

## Purpose

Entities define the database schema and relationships between tables. They serve as the bridge between your application and the database.

## Structure

```
entities/
├── user/                       # User-related entities
│   ├── User.js                # Main user entity
│   ├── Role.js                # User roles
│   ├── Department.js           # User departments
│   └── RefreshToken.js         # Refresh tokens
├── [feature]/                 # Feature-specific entities
│   ├── [Entity].js            # Main entity
│   └── [SubEntity].js         # Related entities
└── README.md                  # This file
```

## Entity Guidelines

### 1. **Use EntitySchema Pattern**
```javascript
import { EntitySchema } from "typeorm";

const EntityName = new EntitySchema({
  name: "EntityName",
  tableName: "table_name",
  columns: {
    // Column definitions
  },
  relations: {
    // Relationship definitions
  }
});

export default EntityName;
```

### 2. **Column Definitions**
- Use appropriate data types
- Set nullable/required constraints
- Define unique constraints
- Use proper column names

### 3. **Relationships**
- **One-to-One**: `type: "one-to-one"`
- **One-to-Many**: `type: "one-to-many"`
- **Many-to-One**: `type: "many-to-one"`
- **Many-to-Many**: `type: "many-to-many"`

### 4. **Common Patterns**
- Include `id` as primary key
- Add `createdAt` and `updatedAt` timestamps
- Use proper foreign key relationships
- Define join tables for many-to-many

## Example Entity

```javascript
import { EntitySchema } from "typeorm";

const User = new EntitySchema({
  name: "User",
  tableName: "users",
  columns: {
    id: {
      primary: true,
      type: "int",
      generated: true,
    },
    name: {
      type: "varchar",
      nullable: false,
    },
    email: {
      type: "varchar",
      unique: true,
      nullable: false,
    },
    createdAt: {
      type: "datetime",
      createDate: true,
    },
    updatedAt: {
      type: "datetime",
      updateDate: true,
    },
  },
  relations: {
    posts: {
      target: "Post",
      type: "one-to-many",
      inverseSide: "user"
    }
  }
});

export default User;
```

## File Naming Conventions

- Use PascalCase for entity names
- Use descriptive names
- Group related entities in subdirectories
- Use consistent naming patterns

## Best Practices

1. **Single Responsibility**: Each entity should represent one concept
2. **Clear Relationships**: Define relationships clearly
3. **Proper Indexing**: Add indexes for frequently queried columns
4. **Validation**: Use column constraints for data validation
5. **Naming**: Use consistent naming conventions
6. **Documentation**: Document complex relationships
7. **Migrations**: Use migrations for schema changes

## Common Entity Types

### User Management
- User, Role, Permission, Department

### Business Entities
- Product, Category, Order, Customer

### System Entities
- AuditLog, ErrorLog, Configuration

### File Entities
- File, Document, Image

## Relationship Examples

### One-to-Many
```javascript
relations: {
  posts: {
    target: "Post",
    type: "one-to-many",
    inverseSide: "user"
  }
}
```

### Many-to-Many
```javascript
relations: {
  roles: {
    target: "Role",
    type: "many-to-many",
    joinTable: {
      name: "user_roles",
      joinColumn: { name: "user_id", referencedColumnName: "id" },
      inverseJoinColumn: { name: "role_id", referencedColumnName: "id" }
    }
  }
}
```

## Database Considerations

1. **Indexes**: Add indexes for performance
2. **Constraints**: Use database constraints
3. **Foreign Keys**: Define proper foreign key relationships
4. **Cascading**: Set appropriate cascade options
5. **Soft Deletes**: Consider soft delete patterns
