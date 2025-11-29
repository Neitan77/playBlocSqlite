# Reproductor de Audio con BLoC - Guía de Uso

## 🎵 Características Principales

- ✅ Reproducción de 8 canciones locales con imágenes
- ✅ Controles completos: Play, Pause, Next, Previous, Seek
- ✅ Control de volumen (0-100%)
- ✅ Control de velocidad de reproducción (0.5x - 2.0x)
- ✅ **NUEVO**: Agregar y reproducir canciones desde internet
- ✅ Gestos táctiles para cambiar de canción
- ✅ Menú drawer animado
- ✅ Splash screen personalizado

---

## 🚀 Cómo Ejecutar el Proyecto

### Requisitos
- Flutter SDK 3.9.2 o superior
- Android Studio o IntelliJ IDEA
- Emulador Android o dispositivo físico

### Pasos

1. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

2. **Ejecutar la aplicación**:
   ```bash
   flutter run
   ```

3. **Construir APK** (opcional):
   ```bash
   flutter build apk --release
   ```

---

## 🎼 Cómo Agregar Canciones desde Internet

### Paso a Paso

1. **Abrir el reproductor** de audio

2. **Presionar el botón de configuración** (⚙️) en la esquina superior derecha

3. **Presionar "Agregar Canción desde Internet"** en el modal que aparece

4. **Llenar el formulario**:
   - **URL del MP3**: Pegar la URL completa del archivo MP3
     - Ejemplo: `https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3`
   - **Título**: Nombre de la canción
   - **Artista**: Nombre del artista
   - **Álbum**: (Opcional) Nombre del álbum

5. **Presionar "Agregar"**

6. **Navegar a la canción** usando el botón "Next" (las canciones de internet se agregan al final)

---

## 🔗 URLs de Prueba

Puedes usar estas URLs públicas para probar la funcionalidad:

```
https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3
https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3
https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3
https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3
https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3
```

---

## 📱 Controles del Reproductor

### Controles Principales
- **Play/Pause**: Botón central grande
- **Next**: Botón de flecha derecha
- **Previous**: Botón de flecha izquierda
- **Seek**: Deslizar la barra de progreso

### Gestos
- **Deslizar imagen**: Cambia de canción automáticamente

### Configuración (⚙️)
- **Volumen**: Slider de 0% a 100%
- **Velocidad**: Botones de 0.5x a 2.0x
- **Agregar Canción**: Botón para agregar desde internet

---

## 📂 Estructura del Proyecto

```
lib/
├── blocs/          # Lógica de negocio (BLoC)
├── models/         # Modelos de datos
├── repositories/   # Gestión de datos
├── views/          # Pantallas de la app
├── widgets/        # Componentes reutilizables
└── main.dart       # Punto de entrada
```

---

## 🎨 Canciones Incluidas

1. **All that** - Mayelo
2. **Love** - Diego
3. **Jazz Piano** - Jazira
4. **Bring Me To Life** - Evanescence
5. **Welcome to the Black Parade** - My Chemical Romance
6. **Chop Suey** - System Of A Down
7. **Madrugada** - Enjambre
8. **Du hast** - Rammstein

---

## 📖 Documentación Completa

Para más detalles sobre la implementación y cambios realizados, consulta:

- **[DOCUMENTACION_CAMBIOS.md](DOCUMENTACION_CAMBIOS.md)**: Documentación completa de todos los cambios
- **Actividades 2.1.1 y 2.2.1**: Toda la información necesaria para las actividades

---

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo
- **BLoC**: Arquitectura de gestión de estado
- **audioplayers**: Reproducción de audio
- **flutter_slider_drawer**: Menú drawer animado
- **equatable**: Comparación de objetos

---

## ⚠️ Notas Importantes

1. **Permisos**: La app requiere permiso de INTERNET para reproducir canciones desde URLs
2. **Orden de reproducción**: Las canciones locales se reproducen primero (0-7), luego las de internet (8+)
3. **Imágenes**: Las canciones de internet no tienen imagen, se muestra la primera imagen local
4. **Conexión**: Se requiere conexión a internet para reproducir canciones desde URLs

---

## 🐛 Solución de Problemas

### La canción de internet no se reproduce
- Verificar que la URL sea válida y accesible
- Verificar conexión a internet
- Asegurarse de que la URL termine en `.mp3`

### Error al agregar canción
- Llenar todos los campos obligatorios (URL, Título, Artista)
- Verificar que la URL sea correcta

### No aparece el botón de agregar canción
- Asegurarse de abrir el modal de settings (⚙️)
- Verificar que estés en la pantalla del reproductor

---

## 👨‍💻 Desarrollo

Este proyecto fue desarrollado siguiendo las mejores prácticas de Flutter y la arquitectura BLoC, manteniendo un código sencillo y comprensible para estudiantes.

**Materia**: Programación Móvil  
**Actividades**: 2.1.1 y 2.2.1  
**Fecha**: Noviembre 2025

---

## 📝 Licencia

Este proyecto es con fines educativos.
