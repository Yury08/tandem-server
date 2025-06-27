import { IsNumber, IsString } from 'class-validator';

export class UserWalletDto {
  @IsNumber()
  telegramId: number;

  @IsString()
  walletAddress: string;
}
