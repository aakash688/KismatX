// Department Entity
// Defines user departments

import { EntitySchema } from "typeorm";

const Department = new EntitySchema({
  name: "Department",
  tableName: "departments",
  columns: {
    id: {
      primary: true,
      type: "int",
      generated: true,
    },
    name: {
      type: "varchar",
      unique: true,
      nullable: false,
    },
    description: {
      type: "text",
      nullable: true,
    },
    isActive: {
      type: "boolean",
      default: true,
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
    users: {
      target: "User",
      type: "one-to-many",
      inverseSide: "department"
    }
  }
});

export default Department;
