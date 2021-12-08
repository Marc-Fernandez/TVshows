# Obtenemos información sobre variables que queremos estudiar pero no están diponibles en la base de datos de IMDb. Para ello haremos 'webscrapping' con el paquete rvest, instalado al inicio del código.
# Nota: utilizaremos CSS para seleccionar el elemento que queremos extraer de cada página.
# Para la obtención de la variable "numeroTemporadas".
temporadas_tconst <- c()
numeroTemporadas <- c()
for(tconst in Series$tconst){
  url <- paste0("https://www.imdb.com/title/", tconst, "/episodes")
  listaepisodios <- rvest::read_html(url)
  TemporadasIndividual <- as.integer(listaepisodios %>% rvest::html_node("select#bySeason.current>[selected]") %>% rvest::html_text())
  numeroTemporadas[tconst] <- TemporadasIndividual
  temporadas_tconst[tconst] <- tconst
  # Creamos una latencia entre repeticiones para evitar que el servidor de IMDb nos impida el acceso debido a la entrada rápida a muchas páginas desde la misma IP.
  Sys.sleep(runif(1, 1, 4)) 
}

# Obtenemos información sobre los paises donde se ha creado cada serie.
PaisPrincipal <- c()
Paises_tconst <- c()
for(tconst in Series$tconst){
  url <- paste0("https://www.imdb.com/title/", tconst)
  listapaises <- rvest::read_html(url)
  individualPaises <- as.character(listapaises %>% rvest::html_node("[href*=country_of_origin]") %>% rvest::html_text())
  Paises_tconst[tconst] <- tconst
  PaisPrincipal[tconst] <- individualPaises
  Sys.sleep(runif(1, 1, 4)) 
}

Productoras <- c()
for(tconst in Series$tconst){
  url <- paste0("https://www.imdb.com/title/", tconst, "/companycredits")
  listaProductoras <- rvest::read_html(url)
  nombreProductoras <- listaProductoras %>% rvest::html_node("ul.simpleList") %>% rvest::html_nodes("[href*=company]") %>% rvest::html_text()
  Productoras <- c(Productoras, nombreProductoras)
  Sys.sleep(runif(1, 1, 4))
}
Df_Productoras <- data.frame(Productoras)
View(summary(Df_Productoras$Productoras)) # Para ver el recuento de cuántas series de las que analizamos tiene cada productora. Clasificaremos las grandes productoras como aquellas que hayan participado en la creación de, al menos, 20 series.

# Con el resultado del webscraping anterior, creamos una variable dicotómica donde 1 indica 20 o más series producidas y 0 en caso contrario.
BP_tconst <- c()
Binaria_Productoras <- c()
for(tconst in Series$tconst){
  url <- paste0("https://www.imdb.com/title/", tconst, "/companycredits")
  listaProductoras <- rvest::read_html(url)
  Binaria <- listaProductoras %>% rvest::html_node("ul.simpleList") %>% rvest::html_nodes("[href*=company]") %>% rvest::html_text()
  recuento <- ifelse( Binaria == "Warner Bros. Television" | Binaria == "20th Century Fox Television" | Binaria == "ABC Studios" | Binaria == "CBS Television Studios" | Binaria == "Sony Pictures Television" | Binaria == "Netflix" | Binaria == "British Broadcasting Corporation (BBC)" | Binaria == "Universal Television" | Binaria == "Home Box Office (HBO)" | Binaria == "Universal Cable Productions" | Binaria == "Touchstone Television" | Binaria == "3 Arts Entertainment" | Binaria == "Cartoon Network" | Binaria == "Cartoon Network Studios" | Binaria == "Universal Media Studios (UMS)" | Binaria == "Warner Bros. Animation" | Binaria == "NBC Universal Television" | Binaria == "Amazon Studios" | Binaria == "CBS Paramount Network Television" | Binaria == "CBS Productions" | Binaria == "FX Productions" | Binaria == "Paramount Television", 1, 0)
  # Como hay muchas series con más de una productora, la variable recuento crea un vector dicotómico con un número de observaciones no constante para convertirlo en una sola observación. Sumamos todos los números de la variable, si el resultado es mayor que 0 quiere decir que, por lo menos, una productora grande ha estado implicada en la producción de la serie.
  recuento <- ifelse(sum(recuento) > 0, 1, 0) 
  Binaria_Productoras <- c(Binaria_Productoras, recuento)
  BP_tconst[tconst] <- tconst
  Sys.sleep(runif(1, 1, 4))
}

Distribuidoras <- c()
for(tconst in Series$tconst){
  url <- paste0("https://www.imdb.com/title/", tconst, "/companycredits")
  listaDistribuidoras <- rvest::read_html(url)
  nombreDistribuidoras <- listaDistribuidoras %>% rvest::html_node("ul.simpleList:nth-child(5)") %>% rvest::html_nodes("[href*=company]") %>% rvest::html_text()
  Distribuidoras <- c(Distribuidoras, nombreDistribuidoras) 
  Sys.sleep(runif(1, 1, 4)) # Creamos una latencia entre repeticiones para evitar que el servidor de IMDb nos impida el acceso debido a la entrada rápida a muchas páginas desde la misma IP.
}
Df_Distribuidoras <- data.frame(Distribuidoras)
View(summary(as.factor(Distribuidoras))) # Para ver cuántas veces se repiten las distribuidoras que nos interesa analizar

BD_tconst <- c()
Binaria_Distribuidoras <- c()
for(tconst in Series$tconst){
  url <- paste0("https://www.imdb.com/title/", tconst, "/companycredits")
  listaDistribuidoras <- rvest::read_html(url)
  Binaria <- listaDistribuidoras %>% rvest::html_node("ul.simpleList:nth-child(5)") %>% rvest::html_nodes("[href*=company]") %>% rvest::html_text()
  # Creamos un vector de tantos valores como distribuidoras la serie tenga.
  a <- ifelse(Binaria == "Amazon Prime Video" | Binaria == "Netflix" | Binaria == "HBO", 1, 0) 
  # resumimos el vector anterior en un vector de una observación.
  a <- ifelse(sum(a) > 0, 1, 0)
  Binaria_Distribuidoras <- c(Binaria_Distribuidoras, a)
  BD_tconst[tconst] <- tconst
  Sys.sleep(runif(1, 1, 4))
}
