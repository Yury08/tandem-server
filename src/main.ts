import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors({
    origin: [
      'https://tandem-client-one.vercel.app',
      'http://localhost:3000',
      '*',
    ],
    credentials: true,
  });
  await app.listen(5555);
}
bootstrap();
