// BetDetail Entity
// Stores all individual bets per card, linked to a slip

import { EntitySchema } from "typeorm";

const BetDetail = new EntitySchema({
  name: "BetDetail",
  tableName: "bet_details",
  columns: {
    id: {
      primary: true,
      type: "bigint",
      generated: true,
    },
    slip_id: {
      type: "bigint",
      nullable: false,
    },
    card_number: {
      type: "tinyint",
      nullable: false,
      comment: "Card number the user bet on (1-12)",
    },
    bet_amount: {
      type: "decimal",
      precision: 18,
      scale: 2,
      nullable: false,
      comment: "Amount bet on this card",
    },
    is_winner: {
      type: "boolean",
      default: false,
      comment: "True if this bet won",
    },
    payout_amount: {
      type: "decimal",
      precision: 18,
      scale: 2,
      default: 0.00,
      comment: "Amount won (0 if lost)",
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
    betSlip: {
      target: "BetSlip",
      type: "many-to-one",
      joinColumn: {
        name: "slip_id",
        referencedColumnName: "id",
      },
    },
  },
});

export default BetDetail;


