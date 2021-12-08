# Cargamos los paquetes que utilizaremos para el estudio.
  # En caso que haya que instalar alguno de estos paquetes, se puede utilizar las siguientes funciones: 
    # install.packages("dplyr")
    # install.packages("rvest")
library(dplyr) # Para la manipulación de variables.
library(rvest) # Para hacer 'webscraping' (obtener variables de estudio que no están disponibles en la base de datos original).

# Filtramos para quedarnos únicamente con las observaciones que nos interesan. En este caso son las siguientes características: 
Series <- dplyr::filter(title.basics, titleType == "tvSeries") # Quitamos todos los títulos que no sean series de televisión.
Series <- dplyr::inner_join(Series, title.ratings, by = "tconst") # Unimos aquellas series cuyos datos esten disponibles tanto en "title.ratings" (puntuaciones) y "title.basics" (información general).

  # Eliminamos las variables que no queremos, en este caso "isAdult" (no aplica a las séries).
Series$isAdult <- NULL

  # Géneros que nos interesan. En este caso hacemos tres clasificaciones: (1) Género relevante (2) Género neutro (3) Género irrelevante.
    # (1) Género relevante: Nos interesa en especial estudiar los siguientes géneros: Drama, Comédia, Romance, Crimen, Acción, Thriller. 
    # (2) Género neutro: Genero que no nos resultan de especial interés. No serán objeto de estudio pero no los podemos descartar, de lo contrario estaríamos quitando series que tengan un género relevante por la presencia de un género neutro.
    # (3) Género irrelevante: Géneros que no queremos que estén contenidos en las series de estudio por su naturaleza pero que en IMDb están clasificados como séries. En concreto: Documentales, Noticias, Reality TV y Concursos.
          # NOTA: al quitar generos irrelevantes, estamos quitando observaciones que también contienen generos relevantes. Así pues, si una serie está clasificada como Comedia y, a la vez, como Reality-TV, la descartaremos.
Series <- dplyr::filter(Series, grepl('Drama|Comedy|Romance|Crime|Action|Thriller', genres))
Series <- dplyr::filter(Series, !grepl('Documentary|Game-Show|News|Reality-TV', genres))

  # Series creadas a partir del año 1990. Año en el que se creó IMDb, de donde obtenemos los datos.
Series <- dplyr::filter(Series, startYear >= 1990)

  # Analizaremos el 5% de las series con mayor número de votos.
quantile(Series$numVotes, 0.95) # Nos da como resultado 4855.6
Series <- dplyr::filter(Series, numVotes >= 4855) 

# Creamos tablas de datos con las variables extraídas mediante webscraping.
   # NOTA: Al final de cada función, se encuentra el código del Script "webscraping" utilizado para obtener cada variable.
NumeroTemporadas <- data.frame("tconst"=temporadas_tconst, numeroTemporadas) # Lineas 4-13
ListaPaises <- data.frame("tconst"=Paises_tconst, PaisPrincipal) # Lineas 16-25
Binaria_ProductorasDF <- data.frame("tconst" = BP_tconst, Binaria_Productoras) # Lineas 39-50
Binaria_DistribuidorasDF <- data.frame("tconst" = BD_tconst, Binaria_Distribuidoras) # Lineas 63-74

# Añadimos las series creadas mediante webscraping a la tabla de series.
Series <- dplyr::left_join(Series, ListaPaises, by = "tconst")
Series <- dplyr::left_join(Series, NumeroTemporadas, by = "tconst") 
Series <- dplyr::left_join(Series, Binaria_DistribuidorasDF, by = "tconst") 
Series <- dplyr::left_join(Series, Binaria_ProductorasDF, by = "tconst") 

# Nos aseguramos que cada variable sea de la clase que necesitamos y cambiamos las que no lo son. 
glimpse(Series) #La variable "runtimeMinutes" (duración media de episodos) esá registrada como "character". La queremos cambiar a "string".
Series$runtimeMinutes <- as.integer(Series$runtimeMinutes)

# Cortamos los puntos atípicos
Series <- dplyr::filter(Series, numVotes <= 72367)
Series <- dplyr::filter(Series, averageRating > 5.7)
Series <- dplyr::filter(Series, runtimeMinutes <= 120) # Las series que tienen más de 120 minutos de duración por episodio en la base de datos tienen errores de recolección.

# Normalizamos las variables numVotes y averageRating y hacemos la ponderación para la creación de la variable dependiente Exito.
NV_normalizada <- (Series$numVotes - mean(Series$numVotes)) / sd(Series$numVotes)
AR_normalizada <- (Series$averageRating - mean(Series$averageRating)) / sd(Series$averageRating)
Exito <- (NV_normalizada*0.7) + (AR_normalizada*0.3) + 5
Series <- dplyr::mutate(Series, Exito)

# Creamos variables dicotómicas para cada uno de los cinco paises con mayores series producidas y otra para el resto.
USA <- ifelse(Series$PaisPrincipal == "USA", 1, 0)
Japan <- ifelse(Series$PaisPrincipal == "Japan", 1, 0)
Canada <- ifelse(Series$PaisPrincipal == "Canada", 1, 0)
UK <- ifelse(Series$PaisPrincipal == "UK", 1, 0)
Otros <- ifelse(!grepl('USA|UK|Japan|Canada', Series$PaisPrincipal), 1, 0)
Series <- mutate(Series, USA, UK, Japan, Canada, Otros)

# Creamos una variable dicotómica para cada uno de los géneros relevantes.
Drama <- ifelse(grepl("Drama", Series$genres) == T, 1,0)
Comedy <- ifelse(grepl("Comedy", Series$genres) == T, 1,0)
Romance <- ifelse(grepl("Romance", Series$genres) == T, 1,0)
Crime <- ifelse(grepl("Crime", Series$genres) == T, 1,0)
Action <- ifelse(grepl("Action", Series$genres) == T, 1,0)
Thriller <- ifelse(grepl("Thriller", Series$genres) == T, 1,0)

# Unimos las variables dicotómicas de género a la tabla de series.
Series <- dplyr::mutate(Series, Drama, Comedy, Romance, Crime, Action, Thriller)

for(i in 1990:2020) { 
  nombre <- paste0(i, ".dicotomica")
  assign(nombre, ifelse(Series$startYear == i, 1, 0))
}

# Concatenamos las dicotomicas anuales a la tabla de las series.
Series <- data.frame(Series, 
                     `1990.dicotomica`, 
                     `1991.dicotomica`, 
                     `1992.dicotomica`, 
                     `1993.dicotomica`, 
                     `1994.dicotomica`, 
                     `1995.dicotomica`, 
                     `1996.dicotomica`, 
                     `1997.dicotomica`, 
                     `1998.dicotomica`, 
                     `1999.dicotomica`, 
                     `2000.dicotomica`, 
                     `2001.dicotomica`, 
                     `2002.dicotomica`, 
                     `2003.dicotomica`, 
                     `2004.dicotomica`, 
                     `2005.dicotomica`, 
                     `2006.dicotomica`, 
                     `2007.dicotomica`, 
                     `2008.dicotomica`, 
                     `2009.dicotomica`, 
                     `2010.dicotomica`, 
                     `2011.dicotomica`, 
                     `2012.dicotomica`, 
                     `2013.dicotomica`, 
                     `2014.dicotomica`, 
                     `2015.dicotomica`, 
                     `2016.dicotomica`, 
                     `2017.dicotomica`, 
                     `2018.dicotomica`, 
                     `2019.dicotomica`, 
                     `2020.dicotomica`)

# Para pasar los datos a Stata, extraeremos la tabla "Series" en formato csv.
# NOTA: Es importante que especifiquemos la expresión que utilizaremos para los NAs para facilitar el proceso de importación a Stata.
write.csv(Series, file="Definitiva.csv", na="")

LM <- lm(Exito ~ runtimeMinutes + 
           Binaria_Distribuidoras + 
           Binaria_Productoras + 
           USA + 
           UK + 
           Japan + 
           Canada + 
           Drama + 
           Comedy + 
           Romance + 
           Crime + 
           Action + 
           X1990.dicotomica + 
           X1991.dicotomica + 
           X1992.dicotomica + 
           X1993.dicotomica + 
           X1994.dicotomica + 
           X1995.dicotomica + 
           X1996.dicotomica + 
           X1997.dicotomica + 
           X1998.dicotomica + 
           X1999.dicotomica + 
           X2000.dicotomica + 
           X2001.dicotomica + 
           X2002.dicotomica + 
           X2003.dicotomica + 
           X2004.dicotomica + 
           X2005.dicotomica + 
           X2006.dicotomica + 
           X2007.dicotomica + 
           X2008.dicotomica + 
           X2009.dicotomica + 
           X2010.dicotomica + 
           X2011.dicotomica + 
           X2012.dicotomica + 
           X2013.dicotomica + 
           X2014.dicotomica + 
           X2015.dicotomica + 
           X2016.dicotomica + 
           X2017.dicotomica + 
           X2018.dicotomica + 
           X2019.dicotomica, 
         data = Series)
View(LM)
summary(LM)