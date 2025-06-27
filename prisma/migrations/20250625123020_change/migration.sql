-- DropIndex
DROP INDEX "user_wallet_telegram_id_key";

-- CreateIndex
CREATE INDEX "user_wallet_telegram_id_idx" ON "user_wallet"("telegram_id");
