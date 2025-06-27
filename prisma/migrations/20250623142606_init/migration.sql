-- CreateEnum
CREATE TYPE "PoolStatus" AS ENUM ('active', 'completed', 'refunded');

-- CreateEnum
CREATE TYPE "SplitStatus" AS ENUM ('active', 'completed', 'broken');

-- CreateTable
CREATE TABLE "user_wallet" (
    "id" TEXT NOT NULL,
    "telegram_id" INTEGER NOT NULL,
    "wallet_address" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_wallet_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pool" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "total_amount" DECIMAL(20,9) NOT NULL DEFAULT 0,
    "min_contribution" DECIMAL(20,9) NOT NULL DEFAULT 1,
    "creator" TEXT NOT NULL,
    "start_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "end_at" TIMESTAMP(3) NOT NULL,
    "target_wallet" TEXT NOT NULL,
    "status" "PoolStatus" NOT NULL DEFAULT 'active',
    "is_open" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "pool_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "participant" (
    "id" TEXT NOT NULL,
    "telegram_id" INTEGER NOT NULL,
    "joined_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "contribution" BIGINT NOT NULL DEFAULT 0,
    "sent" BOOLEAN NOT NULL DEFAULT false,
    "invite_token" TEXT,
    "pool_id" TEXT NOT NULL,

    CONSTRAINT "participant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "split_order" (
    "id" TEXT NOT NULL,
    "contract_address" TEXT NOT NULL,
    "buyer_id" INTEGER NOT NULL,
    "seller_id" INTEGER NOT NULL,
    "total_amount" BIGINT NOT NULL,
    "installment_count" INTEGER NOT NULL,
    "installment_amount" BIGINT NOT NULL,
    "next_payment_date" TIMESTAMP(3),
    "status" "SplitStatus" NOT NULL DEFAULT 'active',
    "product_metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "split_order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "split_payment" (
    "id" TEXT NOT NULL,
    "split_order_id" TEXT NOT NULL,
    "installment_number" INTEGER NOT NULL DEFAULT 1,
    "due_date" TIMESTAMP(3) NOT NULL,
    "paid_at" TIMESTAMP(3) NOT NULL,
    "tx_hash" TEXT,
    "penalty_added" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "split_payment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pool_main" (
    "id" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "total_liquidity" DECIMAL(20,9) NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "pool_main_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "liquidity_contributor" (
    "id" TEXT NOT NULL,
    "telegram_id" INTEGER NOT NULL,
    "amount" DECIMAL(20,9) NOT NULL DEFAULT 0,
    "share" DECIMAL(20,9) NOT NULL,
    "locked_until" TIMESTAMP(3),
    "joined_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "pool_main_id" TEXT NOT NULL,

    CONSTRAINT "liquidity_contributor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "split_transaction" (
    "id" TEXT NOT NULL,
    "buyer_id" INTEGER NOT NULL,
    "vendor_id" INTEGER NOT NULL,
    "amount" BIGINT NOT NULL,
    "installments_remaining" INTEGER NOT NULL,
    "status" "SplitStatus" NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "split_transaction_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_wallet_telegram_id_key" ON "user_wallet"("telegram_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_wallet_wallet_address_key" ON "user_wallet"("wallet_address");

-- CreateIndex
CREATE INDEX "pool_creator_idx" ON "pool"("creator");

-- CreateIndex
CREATE INDEX "pool_status_idx" ON "pool"("status");

-- CreateIndex
CREATE INDEX "pool_is_open_idx" ON "pool"("is_open");

-- CreateIndex
CREATE INDEX "pool_end_at_idx" ON "pool"("end_at");

-- CreateIndex
CREATE INDEX "participant_telegram_id_idx" ON "participant"("telegram_id");

-- CreateIndex
CREATE INDEX "participant_pool_id_idx" ON "participant"("pool_id");

-- CreateIndex
CREATE INDEX "split_order_buyer_id_idx" ON "split_order"("buyer_id");

-- CreateIndex
CREATE INDEX "split_order_seller_id_idx" ON "split_order"("seller_id");

-- CreateIndex
CREATE INDEX "split_order_status_idx" ON "split_order"("status");

-- CreateIndex
CREATE INDEX "split_payment_split_order_id_idx" ON "split_payment"("split_order_id");

-- CreateIndex
CREATE UNIQUE INDEX "pool_main_address_key" ON "pool_main"("address");

-- CreateIndex
CREATE UNIQUE INDEX "liquidity_contributor_telegram_id_key" ON "liquidity_contributor"("telegram_id");

-- CreateIndex
CREATE INDEX "liquidity_contributor_pool_main_id_idx" ON "liquidity_contributor"("pool_main_id");

-- CreateIndex
CREATE INDEX "split_transaction_buyer_id_idx" ON "split_transaction"("buyer_id");

-- CreateIndex
CREATE INDEX "split_transaction_vendor_id_idx" ON "split_transaction"("vendor_id");

-- CreateIndex
CREATE INDEX "split_transaction_status_idx" ON "split_transaction"("status");

-- AddForeignKey
ALTER TABLE "participant" ADD CONSTRAINT "participant_pool_id_fkey" FOREIGN KEY ("pool_id") REFERENCES "pool"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "split_payment" ADD CONSTRAINT "split_payment_split_order_id_fkey" FOREIGN KEY ("split_order_id") REFERENCES "split_order"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "liquidity_contributor" ADD CONSTRAINT "liquidity_contributor_pool_main_id_fkey" FOREIGN KEY ("pool_main_id") REFERENCES "pool_main"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
