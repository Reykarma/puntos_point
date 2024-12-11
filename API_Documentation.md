
# API Documentation

## API de Autenticación

### 1. Login
- **Endpoint:** `POST /api/v1/auth/login`
- **Descripción:** Permite a los administradores autenticarse y obtener un token JWT.
- **Headers Requeridos:**
  - `Content-Type: application/json`
- **Body:**
  ```json
  {
    "email": "admin@example.com",
    "password": "password123"
  }
  ```
- **Respuestas:**
  - **200 OK** (Credenciales válidas)
    ```json
    {
      "token": "jwt_token"
    }
    ```
  - **401 Unauthorized** (Credenciales inválidas)
    ```json
    {
      "error": "Invalid credentials"
    }
    ```

---

## API de Reportes

### 2. Top Products by Category
- **Endpoint:** `GET /api/v1/reports/top_products_by_category`
- **Descripción:** Devuelve los productos más comprados agrupados por categoría.
- **Headers Requeridos:**
  - `Authorization: Bearer jwt_token`
  - `Content-Type: application/json`
- **Respuestas:**
  - **200 OK**
    ```json
    [
      {
        "category_name": "Electronics",
        "products": [
          { "id": 1, "name": "Smartphone", "total_purchases": 50 },
          { "id": 2, "name": "Laptop", "total_purchases": 30 }
        ]
      }
    ]
    ```
  - **401 Unauthorized**
    ```json
    {
      "error": "Unauthorized"
    }
    ```

### 3. Top Revenue Products by Category
- **Endpoint:** `GET /api/v1/reports/top_revenue_products_by_category`
- **Descripción:** Devuelve los 3 productos con mayor recaudación agrupados por categoría.
- **Headers Requeridos:**
  - `Authorization: Bearer jwt_token`
  - `Content-Type: application/json`
- **Respuestas:**
  - **200 OK**
    ```json
    [
      {
        "category_name": "Electronics",
        "top_3_products": [
          { "id": 1, "name": "Smartphone", "total_revenue": 5000 },
          { "id": 2, "name": "Laptop", "total_revenue": 3000 }
        ]
      }
    ]
    ```
  - **401 Unauthorized**
    ```json
    {
      "error": "Unauthorized"
    }
    ```

---

## API de Compras

### 4. Listado de Compras Filtradas
- **Endpoint:** `GET /api/v1/purchases`
- **Descripción:** Devuelve las compras realizadas, filtradas por fecha y categoría.
- **Headers Requeridos:**
  - `Authorization: Bearer jwt_token`
  - `Content-Type: application/json`
- **Parámetros de Consulta (Query Params):**
  - `date_from`: Fecha de inicio (e.g., `2024-01-01`).
  - `date_to`: Fecha de fin (e.g., `2024-12-31`).
  - `category_id`: ID de la categoría (opcional).
- **Respuestas:**
  - **200 OK**
    ```json
    [
      { "id": 1, "product_name": "Smartphone", "client_name": "John Doe", "quantity": 2, "total_price": 1000 },
      { "id": 2, "product_name": "Laptop", "client_name": "Jane Smith", "quantity": 1, "total_price": 1500 }
    ]
    ```
  - **401 Unauthorized**
    ```json
    {
      "error": "Unauthorized"
    }
    ```

### 5. Conteo de Compras por Granularidad
- **Endpoint:** `GET /api/v1/purchases/count_by_granularity`
- **Descripción:** Devuelve el conteo de compras basado en una granularidad (hora, día, semana, año).
- **Headers Requeridos:**
  - `Authorization: Bearer jwt_token`
  - `Content-Type: application/json`
- **Parámetros de Consulta (Query Params):**
  - `granularity`: Nivel de granularidad (e.g., `hour`, `day`, `week`, `year`).
  - `date_from`: Fecha de inicio (e.g., `2024-01-01`).
  - `date_to`: Fecha de fin (e.g., `2024-12-31`).
- **Respuestas:**
  - **200 OK**
    ```json
    {
      "2024-01-01": 10,
      "2024-01-02": 15
    }
    ```
  - **401 Unauthorized**
    ```json
    {
      "error": "Unauthorized"
    }
    ```

---

## Notas Adicionales
1. **Autenticación:**
   - Todas las APIs, excepto la de autenticación (`/auth/login`), requieren un token JWT válido en el encabezado `Authorization`.

2. **Errores Comunes:**
   - `401 Unauthorized`: Asegúrate de proporcionar un token JWT válido y que este no haya expirado.
   - `400 Bad Request`: Verifica que todos los parámetros requeridos estén presentes y sean válidos.

3. **Formato de Respuesta:**
   - Todas las respuestas están en formato JSON.
