Replicando la tabla 2
================
Norman Simón Rodríguez
\- Mayo 07 de 2018

Replicando la tabla 2 (Pre-post disgregado por sexo)
====================================================

Esta tabla (pág. 196) nos muestra estadísticas descriptivas de los
participantes en el programa, disgregando por sexo. Sólo se tienen en
cuenta las personas a las que se les pudo hacer la entrevista pre en
2004 y la entrevista post en 2006. Para eliminar a la gente que
“desapareció” en ese tiempo, vamos a usar la función `subset()`; con
`NROW()` podemos también calcular a cuánta gente no se le pudo hacer
encuesta de seguimiento:

``` r
library(foreign) # Importamos el paquete foreign para poder usar la función read.dta()
datos <- read.dta("datos/AEJApp-20090168_data.dta")
datos_presentes <- subset(datos, datos$dcontinue==1)
NROW(datos) - NROW(datos_presentes)
```

En R, si quisiéramos ver por ejemplo la edad promedio en el pre
agrupando por sexo, usaríamos la función `aggregate()`:

``` r
aggregate(datos_presentes$age_lb, by=list(datos_presentes$dwomen), FUN=mean)
```

Vemos que los números concuerdan con los del artículo. Podríamos hacer
lo mismo para los años de educación:

``` r
aggregate(datos_presentes$educ_lb, by=list(datos_presentes$dwomen), FUN=mean)
```

En este caso el resultado fue `NA`. Esto se debe a que cuando hay NAs, R
no calcula la función media. Para eliminar los NAs del cálculo y así
poder hacer el cálculo, añadimos un argumento adicional a la función:

``` r
aggregate(datos_presentes$educ_lb, by=list(datos_presentes$dwomen), FUN=mean, na.rm=TRUE)
```

Y ahora tenemos unos datos que concuerdan con los del paper,
*redondeados*. Podemos redondear directamente en R si queremos:

``` r
round ( aggregate(datos_presentes$educ_lb, by=list(datos_presentes$dwomen), FUN=mean, na.rm=TRUE), 1 )
```

En la tabla vemos que hay unos números entre paréntesis. Esos números
corresponden a la desviación estándar (que es una medida de dispersión,
a diferencia de la media, que es una medida de tendencia central). Vamos
a calcular esas desviaciones estándar. Para la edad, por ejemplo:

``` r
desv <- aggregate(datos_presentes$age_lb, by=list(datos_presentes$dwomen), FUN=sd, na.rm=TRUE)
round( desv , 2 )
```

Y para los años de educación:

``` r
desv <- aggregate(datos_presentes$educ_lb, by=list(datos_presentes$dwomen), FUN=sd, na.rm=TRUE)
round( desv , 2 )
```

En este caso los números son ligeramente diferentes. Aparentemente esto
se debe a diferencias algorítmicas entre Stata y R o a que los
investigadores hicieron un redondeo más extremo:

``` r
desv <- aggregate(datos_presentes$educ_lb, by=list(datos_presentes$dwomen), FUN=sd, na.rm=TRUE)
round( desv , 1 )
```

En R podemos hacer este mismo procedimiento para todas las variables al
mismo tiempo:

``` r
promedios <- aggregate(datos_presentes, by=list(datos_presentes$dwomen), FUN=mean, na.rm=TRUE)
round(promedios, 2)
```

Quizá sea más fácil de ver si trasponemos el dataframe (la variable
`Group.1` es el sexo):

``` r
promedios <- aggregate(datos_presentes, by=list(datos_presentes$dwomen), FUN=mean, na.rm=TRUE)
t ( round(promedios, 2) )
```

Y ahora con las desviaciones estándar:

``` r
desv <- aggregate(datos_presentes, by=list(datos_presentes$dwomen), FUN=sd, na.rm=TRUE)
t ( round(desv, 2) )
```

La variable `select` nos genera un error, lo cual se debe a que no es
una variable cuantitativa, sino categórica. Podemos verlo con el comando
`head()`:

``` r
head(datos_presentes$select)
```

Esta variable nos dice si la persona está en grupo de control
(“control”) o en grupo de tratamiento (“selected”). ¿Cuántas personas
están en control y cuántas en tratamiento? Hagamos una tabla de
frecuencias absolutas:

``` r
table(datos_presentes$select)
```

¿Y cuántas personas son hombres y cuántas mujeres, según estatus de
tratamiento?

``` r
table(datos_presentes[,c("select","dwomen")])
```

¿Para qué sirve el comando `c()`? Para crear vectores. En este caso
creamos un vector con los nombres de las columnas y le dijimos a R que
sólo tuviera en cuenta esas columnas. Un vector sencillo:

``` r
vector_sencillo <- c(1,2,3,4,5,888)
vector_sencillo
vector_con_letras <- c(vector_sencillo, "hola")
vector_con_letras
```

Contenido
---------

1.  [Preliminares](preliminares.md)
2.  [Exploración inicial de los datos](exploracion.md)
3.  [Estadísticas descriptivas en línea de base](tabla2.md)
4.  [Tabla de balance](tabla3.md)
5.  [Tabla de resultados](tablaresultados.md)
