Replicando la tabla de balance
================
Norman Simón Rodríguez
\- Mayo 07 de 2018

Replicando la tabla 3 (tabla de balance)
========================================

En la página 199 está la tabla de balance (pre) de la RCT. Carguemos los
datos:

``` r
library(foreign) # Importamos el paquete foreign para poder usar la función read.dta()
datos <- read.dta("datos/AEJApp-20090168_data.dta")
datos_presentes <- subset(datos, datos$dcontinue==1)
```

Como hay diferencias sustanciales en las características de las personas
según la ciudad en donde vivan (por ejemplo, en Bogotá hay más
oportunidades laborales que en Baranquilla), hay que eliminar esas
características antes de hacer la comparación para “nivelar” a todas las
personas o ponerlas en las mismas condiciones. Esto se puede hacer ya
que el efecto de pertenecer a una ciudad o a una institución educativa
en particular es el mismo para todos los que pertenecen a ella (se
supone), y de ese modo, si a todos los individuos se les resta el efecto
ciudad/institución/curso, vamos a quedar con sus características
“reales” o “intrínsecas”. Para hacer esto usaremos un método conocido
como regresión lineal con efectos fijos.

Primero separamos los datos entre hombres y mujeres:

``` r
datos_presentes$select <- as.character(datos_presentes$select)
datos_presentes$select[datos_presentes$select=="control"] <- 0
datos_presentes$select[datos_presentes$select=="selected"] <- 1
datos_presentes$select <- as.numeric(datos_presentes$select)

mujeres = subset(datos_presentes, (datos_presentes$dwomen==1) & (!is.na(datos_presentes$city)) & (!is.na(datos_presentes$codigo_ecap)) & (!is.na(datos_presentes$codigo_curs)) )

hombres = subset(datos_presentes, (datos_presentes$dwomen==0) & (!is.na(datos_presentes$city)) & (!is.na(datos_presentes$codigo_ecap)) & (!is.na(datos_presentes$codigo_curs)) )
```

Calculemos la diferencia en horas trabajadas según estatus de
tratamiento y sexo:

``` r
horas_muj <- lm( mujeres$hours_04 ~ mujeres$select + factor(mujeres$city) + factor(mujeres$codigo_ecap) + factor(mujeres$codigo_curs ) )
print("Mujeres")
summary(horas_muj)$coefficients[2,]

horas_hom <- lm( hombres$hours_04 ~ hombres$select + factor(hombres$city) + factor(hombres$codigo_ecap) + factor(hombres$codigo_curs) )
print("Hombres")
summary(horas_hom)$coefficients[2,]
```

Ahora calculemos las medias para cada grupo de control:

``` r
tabla_muj <- aggregate(mujeres, by=list(mujeres$select), FUN=mean, na.rm=TRUE)
tabla_hom <- aggregate(hombres, by=list(hombres$select), FUN=mean, na.rm=TRUE)

t(tabla_muj)
```

¿Qué notamos?

Tarea
=====

Como tarea les queda hacer este mismo ejercicio para las demás
variables.
