Replicando una RCT (taller Universidad Nacional)
================
Norman Simón Rodríguez
-Mayo 07 de 2018

¿Qué es una RCT?
----------------

La sigla RCT en inglés significa *Randomised Controlled Trial*, que
podemos traducir al español como *Ensayo Controlado Aleatorizado*.

¿En qué consiste la intervención que se evaluó?
-----------------------------------------------

Los investigadores evaluaron una intervención educativa usando un ensayo
controlado aleatorizado. La intervención estaba dirigida a jóvenes en
situación de vulnerabilidad y consistía en un programa de entrenamiento
en capacidades laborales. Su objetivo era mejorar los prospectos
laborales de los jóvenes menos favorecidos. Un resumen de la evaluación
(en inglés) puede encontrarse
[aquí](https://www.povertyactionlab.org/evaluation/vocational-training-disadvantaged-youth-colombia).
El artículo completo está en este
[link](https://www.povertyactionlab.org/sites/default/files/publications/472%20-%20training%20disadvantaged%20youth%20in%20Colombia%20July2011%20AEA.pdf).
A continuación presentamos algunos puntos clave para tener en cuenta:

-   **Población intervenida:** 80 mil hombres y mujeres entre los 18 y
    los 25 años de edad, desempleados, pertenecientes al 20% más pobre
    de la población.

-   **Ubicación geográfica:** Los jóvenes intervenidos habitaban en
    Barranquilla, Bogotá, Bucaramanga, Cali, Cartagena, Manizales o
    Medellín.

-   **Temporalidad:** El programa de educación se realizó entre 2002 y
    2006, pero la evaluación sólo tuvo en cuenta la cohorte de 2005.

-   **Investigadores principales:** Orazio Attanasio, Arlen Guarín,
    Adriana Kugler, Carlos Medina, Costas Meghir.

-   **Instituciones patrocinadoras:** DNP, Econometría S.A., SEI
    Consultores, Economic and Social Research Council, Universidad de
    Houston.

-   **Forma de aleatorización:** Se les instruyó a las 114 instituciones
    educativas participantes que hicieran una lista de estudiantes
    elegibles, con la condición de que el número de personas en la lista
    fuera mayor a la cantidad de personas que podrían recibir en los
    cursos de capacitación. Así, por ejemplo, una institución con
    capacidad para 100 estudiantes haría una lista de 150.
    Posteriormente se hizo un sorteo entre los aspirantes para
    determinar quiénes entrarían a los cursos (grupo de tratamiento) y
    quiénes no (grupo de control).

Los datos
---------

Los datos que usaremos en este tutorial se encuentran en este
[link](https://www.aeaweb.org/articles?id=10.1257/app.3.3.188).

El diccionario de datos es el siguiente:

El software
-----------

El programa informático que los investigadores utilizaron para hacer el
estudio se llama [STATA](https://www.stata.com/), pero nosotros usaremos
una herramienta diferente, llamada [R](https://www.r-project.org/). En
teoría, los resultados deben ser siempre los mismos aunque se use
software diferente.

Cargando los datos
------------------

Los datos se encuentran en el archivo `datos/AEJApp-20090168_data.dta`,
que es un archivo de Stata. Para leerlo en R vamos a usar el siguiente
comando:

``` r
library(foreign) # Importamos el paquete foreign para poder usar la función read.dta()
datos <- read.dta("datos/AEJApp-20090168_data.dta")
```

Explorando los datos
====================

Podemos mirar algunas estadísticas descriptivas rápidas de los datos con
el comando `summary()`:

``` r
summary(datos)
```

Si, por ejemplo, quisiéramos saber cuál es la proporción de mujeres en
la muestra de estudio, podríamos simplemente hallar el promedio
aritmético de la variable `dwomen`, que es una variable dummy:

``` r
mean(datos$dwomen)
```

Si además estamos interesados en saber cuántos hombres y cuántas mujeres
hay (no sólo el porcentaje de mujeres), podemos hacer una tabla de
frecuencias absolutas con la función `table()` (recordando que un valor
de `1` corresponde a mujer y uno de `0` a hombre):

``` r
table(datos$dwomen)
```

Podemos también crear un histograma para mirar la distribución de
salarios en la línea de base (la variable `salary_04`), es decir, en el
“pre”:

``` r
options(scipen=5) # Comente esta línea para ver qué pasa con el gráfico.
hist(datos$salary_04
     , main="Distribución de los salarios en la línea base"
     , xlab="Salario real en COP"
     , ylab="Frecuencia absoluta"
     , breaks=15
     , col="gray")
```

Podemos hacer este mismo histograma, pero para los salarios *después de
haber desarrollado la intervención* (en el “post”). La variable de
interés es `salary_06`.

``` r
options(scipen=5) # Comente esta línea para ver qué pasa con el gráfico.
hist(datos$salary_06
     , main="Distribución de los salarios en la línea final"
     , xlab="Salario real en COP"
     , ylab="Frecuencia absoluta"
     , breaks=15
     , col="gray")
```

A juzgar por este diagrama, la distribución de salarios post-tratamiento
es:

-   Unimodal.
-   Bimodal.

¿Qué podría estar causando esto?

Posiblemente necesitemos separar los datos en grupo de tratamiento y
control.

``` r
control = subset(datos, datos$select == 'control')
tratamiento = subset(datos, datos$select == 'selected')

options(scipen=5)
hist(control$salary_06
     , main="Distribución de los salarios en la línea final (CONTROL)"
     , xlab="Salario real en COP"
     , ylab="Frecuencia absoluta"
     , breaks=15
     , col="gray")

options(scipen=5)
hist(tratamiento$salary_06
     , main="Distribución de los salarios en la línea final (TRAT.)"
     , xlab="Salario real en COP"
     , ylab="Frecuencia absoluta"
     , breaks=15
     , col="gray")
```
