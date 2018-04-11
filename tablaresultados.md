Replicando las tablas de resultados
================
Norman Simón Rodríguez
\- Mayo 07 de 2018

La tabla 4A
-----------

Cargamos los datos nuevamente (no es necesario si ya los tenemos
cargados):

``` r
library(foreign) # Importamos el paquete foreign para poder usar la función read.dta()
datos <- read.dta("datos/AEJApp-20090168_data.dta")
datos_presentes <- subset(datos, datos$dcontinue==1)
```

Ahora separamos los datos entre hombres y mujeres:

``` r
datos_presentes$select <- as.character(datos_presentes$select)
datos_presentes$select[datos_presentes$select=="control"] <- 0
datos_presentes$select[datos_presentes$select=="selected"] <- 1
datos_presentes$select <- as.numeric(datos_presentes$select)

mujeres = subset(datos_presentes, (datos_presentes$dwomen==1) & (!is.na(datos_presentes$city)) & (!is.na(datos_presentes$codigo_ecap)) & (!is.na(datos_presentes$codigo_curs)) )

hombres = subset(datos_presentes, (datos_presentes$dwomen==0) & (!is.na(datos_presentes$city)) & (!is.na(datos_presentes$codigo_ecap)) & (!is.na(datos_presentes$codigo_curs)) )
```

Vamos a replicar la primera fila de la tabla, las medias en el grupo de
control para el *post* (ahora `Group.1` ¿qué representa?):

``` r
pf <- aggregate(mujeres, by=list(mujeres$select), FUN=mean, na.rm=TRUE)
t(round(pf,3))
```

Vemos que para esta primera línea los datos coinciden perfectamente.

Ahora vamos a replicar el panel A de esta misma tabla, el cual estima el
efecto de la intervención, que es el número que más nos interesa. Usamos
una regresión lineal con efectos fijos para eliminar el efecto no
aleatorio de la ciudad, institución y curso y así quedar sólo con los
efectos individuales.

Para las horas trabajadas:

``` r
horas_muj <- lm( mujeres$hours_06 ~ mujeres$select + factor(mujeres$city) + factor(mujeres$codigo_ecap) + factor(mujeres$codigo_curs ) )
print("Horas")
summary(horas_muj)$coefficients[2,]
```

Para el salario:

``` r
salario_muj <- lm( mujeres$salary_06 ~ mujeres$select + factor(mujeres$city) + factor(mujeres$codigo_ecap) + factor(mujeres$codigo_curs ) )
print("Salarios")
summary(salario_muj)$coefficients[2,]
```

Para el término de contrato (“tenure”):

``` r
tenure_muj <- lm( mujeres$tenure_06 ~ mujeres$select + factor(mujeres$city) + factor(mujeres$codigo_ecap) + factor(mujeres$codigo_curs ) )
print("Término de contrato")
summary(tenure_muj)$coefficients[2,]
```

Un efecto negativo y significativo.

Los números son ligeramente diferentes, aunque se está usando la misma
función matemática (regresión lineal con efectos fijos). Se puede
consultar la documentación de la función correspondiente en Stata
(`areg`) [aquí](https://www.stata.com/manuals13/rareg.pdf) y
explicaciones de la función correspondiente en R (`lm`)
[aquí](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/lm.html)
y
[aquí](https://stats.idre.ucla.edu/r/modules/coding-for-categorical-variables-in-regression-models/)
(sección 1).

En cuanto al panel B, en este panel no sólo se controlan los efectos
fijos de ciudad/institución/curso sino también las características de
línea de base. En teoría, los resultados del panel B no deben ser muy
diferentes a los del panel A, porque se supone que la aleatorización
elimina los efectos de esas covariables.

El cálculo de estas cifras es un tanto complejo y por esta razón no lo
incluimos en este tutorial.

La tabla 4B
-----------

Ahora los resultados para los hombres. La primera fila:

``` r
pf <- aggregate(hombres, by=list(hombres$select), FUN=mean, na.rm=TRUE)
t(round(pf,3))
```

El panel A. Para las horas trabajadas:

``` r
horas_hom <- lm( hombres$hours_06 ~ hombres$select + factor(hombres$city) + factor(hombres$codigo_ecap) + factor(hombres$codigo_curs ) )
print("Horas")
summary(horas_hom)$coefficients[2,]
```

Para el salario:

``` r
salario_hom <- lm( hombres$salary_06 ~ hombres$select + factor(hombres$city) + factor(hombres$codigo_ecap) + factor(hombres$codigo_curs ) )
print("Salarios")
summary(salario_hom)$coefficients[2,]
```

Para el término de contrato (“tenure”):

``` r
tenure_hom <- lm( hombres$tenure_06 ~ hombres$select + factor(hombres$city) + factor(hombres$codigo_ecap) + factor(hombres$codigo_curs ) )
print("Término de contrato")
summary(tenure_hom)$coefficients[2,]
```

Nuevamente tenemos pequeñas diferencias numéricas, pero los resultados
son consistentes con los hallados en el artículo (los efectos para los
hombres no son estadísticamente significativos, excepto el efecto en el
término de los contratos, que es de cerca de -3 meses (ver pág. 204 del
paper)).

Contenido
---------

1.  [Preliminares](preliminares.md)
2.  [Exploración inicial de los datos](exploracion.md)
3.  [Estadísticas descriptivas en línea de base](tabla2.md)
4.  [Tabla de balance](tabla3.md)
5.  [Tabla de resultados](tablaresultados.md)
