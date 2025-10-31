// BetSlip Entity
// One slip per user betting action, contains barcode and total bet info

import { EntitySchema } from "typeorm";

const BetSlip = new EntitySchema({
  name: "BetSlip",
  tableName: "bet_slips",
  columns: {
    id: {
      primary: true,
      type: "bigint",
      generated: true,
    },
    slip_id: {
      type: "varchar",
      length: 50,
      unique: true,
      nullable: false,
    },
    user_id: {
      type: "bigint",
      nullable: false,
    },
    game_id: {
      type: "varchar",
      length: 50,
      nullable: false,
    },
    total_amount: {
      type: "decimal",
      precision: 18,
      scale: 2,
      nullable: false,
      comment: "Sum of all bets in this slip",
    },
    barcode: {
      type: "varchar",
      length: 255,
      unique: true,
      nullable: false,
      comment: "Barcode for slip verification",
    },
    total_payout: {
      type: "decimal",
      precision: 18,
      scale: 2,
      default: 0.00,
      comment: "Sum of winnings for this slip",
    },
    status: {
      type: "enum",
      enum: ["pending", "settled", "lost"],
      default: "pending",
      comment: "Indicates payout status",
    },
    created_at: {
      type: "datetime",
      default: () => "CURRENT_TIMESTAMP",
    },
    updated_at: {
      type: "datetime",
      default: () => "CURRENT_TIMESTAMP",
      onUpdate: "CURRENT_TIMESTAMP",
    },
  },
  relations: {
    user: {
      target: "User",
      type: "many-to-one",
      joinColumn: {
        name: "user_id",
        referencedColumnName: "id",
      },
    },
  },
});

export default BetSlip;


