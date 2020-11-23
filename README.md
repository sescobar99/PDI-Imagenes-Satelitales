# PDI-Imagenes-Satelitales

TO DO

* Organizar Landsat readme (incluirlo en README)
* Añadir descripcion del proyecto

En la carpeta [Tests](./Tests/) se encuentran: el [archivo principal](./Tests/main.m) que es un ejecutable de matlab y la funcion createMask(la cual es usada en el mismo)

En la carpeta [K-means](./K-means/) se encuentran la ejecucion del segmentado usando k-means para seprara la capa vegetal del resto de la imagen

En la carpeta [NDVI](./NDVI/) se encuentran primeras pruebas en el uso de multiple bandas (por el momento de landsat 8) para hallar el Indice de vegetacion de diferencia normalizada (NDVI) con el fin de resaltar la capa vegetal para su posterior segmentacion.

En la carpeta [GUI](./GUI/) se encuentra lo relativo a la interfaz de usuario:  imagenes, archivos y especialmente un [Mock Up](./GUI/mockup.jpg)