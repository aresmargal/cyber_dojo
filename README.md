# CyberDojo

**CyberDojo** es una aplicación móvil desarrollada con **Flutter**, que busca introducir al usuario de manera sencilla, divertida y gamificada en el mundo de la ciberseguridad básica.

---

## Características principales

-  Aprendizaje interactivo mediante lecciones y cursos.  
-  Contenidos diferentes dependiendo del nivel de conocimiento.  
-  Sistema de rangos tipo “dojo ninja” para motivar el progreso.  
-  Interfaz amigable con paleta de color establecida.
-  Enfoque educativo centrado en buenas prácticas de ciberseguridad.
-  Recompensas con medallas y cinturones por cursos completados.  

---

##  Instalación y ejecución

Para ejecutar **CyberDojo** localmente:

```bash
# Clonar el repositorio
git clone https://github.com/aresmargal/cyber_dojo.git

# Entrar en el directorio
cd CyberDojo

# Instalar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run

```
---


## Desarrollo del FrontEnd: Comparativa Mockups VS Aplicación Final

Enlace Figma con la comparación https://www.figma.com/design/ni8arLnCXLH9yakolbevKy/CyberDojo?node-id=0-1&t=NUlZ6M8dnlUMd9nu-1 

## Desarrollo del BackEnd

Actualmente (13/11/2025) se está desarrollando la parte del back-end utilizando Firebase, específicamente Firestore Database. Se ha implementado la conexión con la colección `users`, que soporta las pantallas de login y registro (`loginScreen` y `registerScreen`). 

El código relacionado se encuentra en la rama `mainFirebase`.
