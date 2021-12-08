# [UPF] Seminar paper - ¿What makes television shows successful? Using linear regression to model success?

This is a discontinued project. The initial data downloaded from IMDb containing can be found in https://www.imdb.com/interfaces/ under the names "title.basics.tsv.gz" and "title.ratings.tsv.gz"

—————

IMPORTANT NOTE #1:

All the data obtained in the study was accessed before 14/04/2020. Any attempt of replicating the study might result in different outcomes for this reason. Furthermore, IMDb's web structure might change, rendering the web scrapping code obsolete.

IMPORTANT NOTE #2: 

This project was carried out in Spanish. The below information on variables, the report and the code have not been translated into English

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
