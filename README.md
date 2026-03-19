# CRM Tuberias y Valvulas Mobile

Demo mobile-first en Flutter para CRM comercial de distribuidora industrial.

## Estado actual
- Arquitectura Clean Architecture por `features`.
- API simulada con contratos de endpoints listos para backend real.
- `Riverpod` con anotaciones y generación de providers.
- Cliente HTTP preparado con `Dio` + adapter.

## Stack
- Flutter 3.38+
- Riverpod (`flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`)
- GoRouter
- Dio

## Estructura
```text
lib/
  app/
    router/
  core/
    design_system/
    network/
    providers/
    wrappers/
  features/
    dashboard/
    customers/
    leads/
    opportunities/
    tasks/
    activities/
    ai_assistant/
```

Cada feature incluye:
- `domain`: entities, repositories (contracts), usecases.
- `infrastructure`: datasources, repository impl, DTOs request/response.
- `presentation`: providers y UI.

## Endpoints mock (contratos)
- `GET /dashboard/summary`
- `GET /customers`
- `GET /leads`
- `GET /opportunities`
- `PATCH /opportunities/{id}/stage`
- `GET /tasks`
- `PATCH /tasks/{id}/complete`
- `GET /activities`
- `GET /ai/insights`
- `POST /ai/follow-up-draft`

## Como correr
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Validacion
```bash
flutter analyze
flutter test
```

## Cambio de mock a backend real
1. Mantener contratos en `core/network/api_endpoints.dart`.
2. Reemplazar provider `httpAdapterProvider` en `core/providers/core_providers.dart`:
   - de `MockHttpAdapter`
   - a `DioHttpAdapter`
3. Mantener DTOs/repositories/usecases sin cambios.

## Navegacion principal
Se usan 3 vistas con `StatefulShellRoute.indexedStack`:
- Inicio (`/dashboard`)
- Pipeline (`/pipeline`)
- IA (`/ai`)

## Flujo Git acordado
- Trabajar en ramas `feature/*`.
- 1 feature = 1 PR.
- Merge manual por revision.
