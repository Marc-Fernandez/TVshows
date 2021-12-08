# TVshows
### Welcome to my project on modeling success factors in TV shows.
Please note this is a discontinued project. The initial data downloaded from IMDb containing can be found in https://www.imdb.com/interfaces/


[UPF] Seminar paper - ¿Por qué tienen éxito las series?
—————
NOTA IMPORTANTE #1: El script “Variables” deberá ser ejecutado por completo (es posible
hacerlo por pasos, en cuyo caso recomendamos que cada ejecución acabe en un comentario
del código) para reconstruir la tabla de datos utilizada para el modelo lineal y el modelo en sí.
Esto se ha hecho para simplificar la visualización de las variables disponibles en la base de
datos (“Datos.RData”) dejando únicamente las imprescindibles.
NOTA IMPORTANTE #2: Posteriormente al inicio del estudio, IMDb cambió la forma de
acceder a los datos. Por consiguiente, los datos utilizados para el estudio pueden diferir de los
datos que IMDb ofrece posteriormente al 14/04/2020.
NOTA IMPORTANTE #3: En caso de problemas de compatibilidad con el archivo de datos
(“Datos.RDat”), hay disponible en la misma carpeta una copia de la base de datos sin los
nombres de las series (“DatosCompatibilidad.RDat”).
—————
En la carpeta "Archivos" se encuentra todo lo necesario para recrear los resultados del estudio.
En ella se encuentran los datos ("Datos.RData") junto con el código separado en dos scripts –
Ambos scripts contienen explicaciones de cada paso realizado.
Para que el código se ejecute correctamente es necesario abrir, al menos, los archivos
“Datos.RData” y “Variables”.
· Datos.RData: Todos los datos necesarios para el estudio. En esta base de datos se
encuentran las tablas “title.basics” y “title.ratings”, obtenidas de IMDb, junto con el resultado de
las variables obtenidas mediante webscraping.
· Webscraping: Código relativo al webscraping de datos. En caso de querer ejecutar el código
de este script, hay que tener en cuenta que la recopilación de datos llevará aproximadamente
una hora por cada “for loop" (6 en total). Por otra parte, un cambio en la estructura HTML de
IMDb podría romper el código y hacer que los resultados obtenidos sean distintos a los que
ahora hay almacenados en la base de datos (“Datos.RData”).
· Variables: Código utilizado para la manipulación de las variables y la creación del modelo de
regresión linear.
Los datos no disponibles se indican mediante “NA”.
La codificación de texto recomendada es UTF-8.
—————
EXPLICACIÓN DE VARIABLES (más detallada en el informe):
tconst: Identificador único de cada título.
primaryTitle: Nombre por el que el título es más conocido.
originalTitle: Nombre original del título, normalmente en el idioma original.
isAdult: Binaria que indica si el título tiene contenido adulto (1 en caso afirmativo, 0 en caso
contrario).
startYear: Año de inicio de la producción del título.
endYear: Año de finalización de la producción del título.

runtimeMinutes: Duración del título. En el caso de las series, duración media de los episodios.
genres: Hasta tres géneros asociados con el título.
averageRating: Media de la puntuación del título. Según IMDb, se trata de una media
ponderada para reflejar más fielmente la percepción general del título.
numVotes: Número de votos realizados al título.
BD_tconst: igual que tconst.
BP_tconst: igual que tconst.
Binaria_Distribuidoras: Dicotómica que indica si la serie está disponible en Netflix, HBO o
Amazon Prime con valor 1 en caso afirmativo.
Binaria_Productoras: Dicotómica que indica si la serie ha estado producida por una gran
productora. 1 en caso afirmativo.
Distribuidoras: Variable utilizada para ver cuántas veces se repetían las distribuidoras de la
variable “Binaria_Distribuidoras”.
numeroTemporadas: Número de temporadas que tiene cada serie de las que analizamos.
Paises_tconst: igual que tconst.
PaisPrincipal: País de producción del título.
Productoras: Variable utilizada para determinar cuáles son las grandes productoras.
temporadas_tconst: igual que tconst.
