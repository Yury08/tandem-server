import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { UserWalletDto } from './dto/userWallet.dto';

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  async getWallet(wallet_address: string) {
    return this.prisma.userWallet.findUnique({
      where: {
        wallet_address,
      },
    });
  }

  async createUserWallet(dto: UserWalletDto) {
    // Проверяем, есть ли уже такой кошелек
    const existing = await this.prisma.userWallet.findUnique({
      where: { wallet_address: dto.walletAddress },
    });
    if (existing) return 'Wallet already exist';
    const userWallet = {
      telegramId: dto.telegramId,
      wallet_address: dto.walletAddress,
    };
    return this.prisma.userWallet.create({
      data: userWallet,
    });
  }
}
