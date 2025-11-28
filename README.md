# Proyecto E-Commerce Sample

Este es un proyecto Flutter de ejemplo que demuestra una implementación de una aplicación de comercio
electrónico simple. La aplicación sigue los principios de **Clean Architecture** para garantizar un código
escalable, mantenible y comprobable.

## Arquitectura

El proyecto está dividido en tres capas principales:

-   **Data:** Responsable de la obtención de datos (desde una API remota) y el almacenamiento en caché local. Contiene implementaciones concretas de las fuentes de datos y repositorios.
-   **Domain:** Contiene la lógica de negocio central de la aplicación. Incluye las entidades, los casos de uso y las interfaces (contratos) de los repositorios. Es independiente de cualquier framework de UI o fuente de datos.
-   **Presentation:** Contiene la UI (widgets de Flutter) y la lógica de presentación (BLoC). Se comunica con la capa de dominio a través de casos de uso.

---

## Documentación

### Diseño de Modelos de Datos

Los modelos de datos (DTOs - Data Transfer Objects) se encuentran en `lib/src/data/models`. Estos modelos están diseñados para mapear directamente las respuestas JSON de la API.

**Ejemplo (`ProductModel`):**
El archivo `lib/src/data/models/product_model.dart` define la estructura del producto.

-   Utiliza un método factory `fromJson(Map<String, dynamic> json)` para deserializar el mapa JSON en una instancia de `ProductModel`.
-   Incluye un método `toEntity()` que convierte el modelo de la capa de datos (`ProductModel`) en una entidad de la capa de dominio (`Product`). Esto es crucial para desacoplar la capa de dominio de las especificidades de la fuente de datos.

### Solicitud y Procesamiento de la API

La lógica para interactuar con la API remota se encuentra en la capa de `data`, específicamente en `lib/src/data/datasources/`.

-   **Contrato:** La interfaz `ProductRemoteDatasource` define los métodos para obtener datos de productos.
-   **Implementación:** La clase `ProductRemoteDatasourceImpl` (`lib/src/data/datasources/product_remote_datasource_impl.dart`) implementa esta interfaz.
    -   Utiliza el paquete `http` para realizar llamadas GET a la API de [Fake Store API](https://fakestoreapi.com/).
    -   Parsea la respuesta JSON y la convierte en una lista de `ProductModel`.
    -   Si la respuesta HTTP no es exitosa (código de estado diferente de 200), lanza una `ServerException`.

### Implementación del Control de Errores con `Either`

Para un manejo de errores robusto y funcional, el proyecto utiliza el tipo `Either` del paquete `dartz`. Esta implementación se puede ver en la capa de repositorios.

-   El `ProductRepositoryImpl` (`lib/src/data/repositories/product_repository_impl.dart`) actúa como intermediario entre la capa de `domain` y la capa de `data`.
-   Dentro de sus métodos, envuelve las llamadas a la fuente de datos en un bloque `try-catch`.
    -   **En caso de éxito:** La llamada al `datasource` devuelve los datos correctamente. El repositorio los envuelve en un `Right`. Por ejemplo: `Right(productList)`.
    -   **En caso de error:** Si el `datasource` lanza una excepción (ej. `ServerException` o `SocketException` por falta de red), el bloque `catch` la captura y la convierte en un tipo de `Failure` personalizado (ej. `ServerFailure`). Este `Failure` se envuelve en un `Left`. Por ejemplo: `Left(ServerFailure())`.

Este enfoque permite que la capa de dominio y presentación manejen los errores de forma explícita y segura, sin necesidad de bloques `try-catch` dispersos, simplemente procesando el resultado `Either` para ver si es `Left` (error) o `Right` (éxito).