"""
Ejemplo de uso de Jupyter en Neovim con Molten
==============================================

Este archivo demuestra cómo usar Molten para ejecutar código Python
de forma interactiva en Neovim.

Instrucciones:
1. Abre este archivo en Neovim: nvim ejemplo_jupyter.py
2. Inicializa Molten: <leader>mi (selecciona python3)
3. Ejecuta las celdas con <leader>ml (línea) o <leader>mv (selección visual)
4. Navega entre celdas con ]c y [c
5. Muestra resultados con <leader>mo
"""

# %% Importaciones
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

print("✓ Librerías importadas correctamente")

# %% Crear datos de ejemplo
np.random.seed(42)

# Crear un DataFrame con datos aleatorios
datos = pd.DataFrame({
    'fecha': pd.date_range('2024-01-01', periods=100),
    'ventas': np.random.randint(100, 1000, 100),
    'categoria': np.random.choice(['A', 'B', 'C'], 100),
    'region': np.random.choice(['Norte', 'Sur', 'Este', 'Oeste'], 100)
})

print(f"✓ Datos creados: {len(datos)} filas")
print(datos.head())

# %% Análisis exploratorio
print("\n=== Estadísticas Descriptivas ===")
print(datos.describe())

print("\n=== Información del DataFrame ===")
print(datos.info())

print("\n=== Valores únicos por categoría ===")
print(datos['categoria'].value_counts())

# %% Análisis por grupo
print("\n=== Ventas promedio por categoría ===")
ventas_por_categoria = datos.groupby('categoria')['ventas'].agg(['mean', 'sum', 'count'])
print(ventas_por_categoria)

print("\n=== Ventas promedio por región ===")
ventas_por_region = datos.groupby('region')['ventas'].agg(['mean', 'sum', 'count'])
print(ventas_por_region)

# %% Visualización: Histograma de ventas
plt.figure(figsize=(12, 6))

plt.subplot(1, 2, 1)
plt.hist(datos['ventas'], bins=20, color='skyblue', edgecolor='black')
plt.xlabel('Ventas')
plt.ylabel('Frecuencia')
plt.title('Distribución de Ventas')
plt.grid(True, alpha=0.3)

# %% Visualización: Boxplot por categoría
plt.subplot(1, 2, 2)
datos.boxplot(column='ventas', by='categoria', ax=plt.gca())
plt.xlabel('Categoría')
plt.ylabel('Ventas')
plt.title('Ventas por Categoría')
plt.suptitle('')  # Remover título automático
plt.grid(True, alpha=0.3)

plt.tight_layout()
plt.show()

print("✓ Gráficos generados")

# %% Visualización: Serie temporal
plt.figure(figsize=(12, 6))
plt.plot(datos['fecha'], datos['ventas'], alpha=0.6, linewidth=0.8)
plt.plot(datos['fecha'], datos['ventas'].rolling(window=7).mean(), 
         color='red', linewidth=2, label='Media móvil (7 días)')
plt.xlabel('Fecha')
plt.ylabel('Ventas')
plt.title('Evolución de Ventas en el Tiempo')
plt.legend()
plt.grid(True, alpha=0.3)
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

print("✓ Serie temporal generada")

# %% Filtrado y transformación
# Filtrar datos de ventas altas
ventas_altas = datos[datos['ventas'] > datos['ventas'].quantile(0.75)]

print(f"\n=== Ventas Altas (Top 25%) ===")
print(f"Total de registros: {len(ventas_altas)}")
print(ventas_altas.head())

# Crear nuevas columnas
datos['mes'] = datos['fecha'].dt.month
datos['dia_semana'] = datos['fecha'].dt.day_name()

print("\n✓ Datos transformados")
print(datos[['fecha', 'mes', 'dia_semana', 'ventas']].head())

# %% Análisis final
print("\n=== Resumen Final ===")
resumen = {
    'Total de ventas': datos['ventas'].sum(),
    'Promedio de ventas': datos['ventas'].mean(),
    'Venta máxima': datos['ventas'].max(),
    'Venta mínima': datos['ventas'].min(),
    'Desviación estándar': datos['ventas'].std(),
    'Categorías': datos['categoria'].nunique(),
    'Regiones': datos['region'].nunique()
}

for clave, valor in resumen.items():
    print(f"{clave}: {valor:.2f}" if isinstance(valor, float) else f"{clave}: {valor}")

print("\n✓ Análisis completado exitosamente!")
