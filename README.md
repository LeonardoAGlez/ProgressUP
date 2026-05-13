# EQUIPO SOBRE-PESO
- Leonardo Alvarez González                202258726
- Osiris Silva García                      202254106
- Paul Sebastian Rosales Lamarque          202251882
- Luis Albeto González Muños               202261451
- Mayra Celeste Pérez Hernández            202247570
- Alejandro Juárez Rojas                    202227957


# NEON PULSE 3D - Progress Up

> Una app fitness gamificada con estética neon dark | Flutter + Supabase + RevenueCat

## 🚀 Setup Rápido

### 1. Instalar Flutter
```powershell
# Verifica que Flutter está en C:\flutter\bin
$env:PATH += ";C:\flutter\bin"
flutter doctor
```

### 2. Configurar Supabase
1. Entra a [app.supabase.com](https://app.supabase.com)
2. Crea un nuevo proyecto
3. Ve a **SQL Editor** y ejecuta `supabase/schema.sql`
4. En `lib/main.dart`, reemplaza:
   ```dart
   const String supabaseUrl = 'https://tu-proyecto.supabase.co';
   const String supabaseAnonKey = 'tu-anon-key';
   ```

### 3. Configurar RevenueCat (Pagos)
1. Crea cuenta en [app.revenuecat.com](https://app.revenuecat.com)
2. Añade tu app (Android + iOS)
3. En `lib/features/subscription/screens/subscription_screen.dart`:
   ```dart
   // En _subscribe(), descomenta:
   await Purchases.configure(PurchasesConfiguration('tu-api-key'));
   final offerings = await Purchases.getOfferings();
   ```

### 4. Ejecutar la app
```bash
flutter run
```

## 📱 Pantallas

| Pantalla | Descripción |
|----------|-------------|
| Login | Autenticación con Supabase + partículas neon |
| Home Dashboard | XP, stats, workout del día |
| Workout Tracker | Timer, series, progreso en tiempo real |
| Social Feed | Posts, stories, likes |
| Leaderboard | Rankings con podio animado |
| Profile | Perfil, logros, historial |
| Subscription PRO | Planes con RevenueCat |

## 🗄️ Base de Datos (Supabase)
- `profiles` — Usuarios con XP y nivel
- `workouts` — Sesiones de entrenamiento
- `exercises` — Ejercicios por sesión
- `posts` — Feed social
- `post_likes` — Sistema de likes
- `leaderboard` — Vista de rankings

## 💳 Pagos (RevenueCat)
- `neonpulse_pro_monthly` → $9.99/mes
- `neonpulse_pro_annual` → $59.99/año (50% ahorro)
- Trial: 7 días gratis

