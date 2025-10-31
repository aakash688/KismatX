// Game Entity
// Stores each 5-minute game session

import { EntitySchema } from "typeorm";

const Game = new EntitySchema({
  name: "Game",
  tableName: "games",
  columns: {
    id: {
      primary: true,
      type: "bigint",
      generated: true,
    },
    game_id: {
      type: "varchar",
      length: 50,
      unique: true,
      nullable: false,
    },
    start_time: {
      type: "datetime",
      nullable: false,
    },
    end_time: {
      type: "datetime",
      nullable: false,
    },
    status: {
      type: "enum",
      enum: ["pending", "active", "completed"],
      default: "pending",
    },
    winning_card: {
      type: "tinyint",
      nullable: true,
      comment: "Winning card number (1-12)",
    },
    payout_multiplier: {
      type: "decimal",
      precision: 5,
      scale: 2,
      default: 10.00,
      comment: "Payout multiplier for winning bets",
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
});

export default Game;


