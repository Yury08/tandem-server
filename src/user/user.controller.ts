import { Body, Controller, HttpCode, Post } from '@nestjs/common';
import { UserWalletDto } from './dto/userWallet.dto';
import { UserService } from './user.service';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post('/wallet_create')
  @HttpCode(201)
  createUserWallet(@Body() createUserWalletDto: UserWalletDto) {
    return this.userService.createUserWallet(createUserWalletDto);
  }
}
