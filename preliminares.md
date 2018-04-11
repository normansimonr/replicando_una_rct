Preliminares
================
Norman Simón Rodríguez
\- Mayo 07 de 2018

¿Qué es una RCT?
----------------

La sigla RCT en inglés significa *Randomised Controlled Trial*, que
podemos traducir al español como *Ensayo Controlado Aleatorizado*. La
lógica es muy sencilla. Supongamos que quiero saber qué comida le sienta
mejor a mi gato Máicol, si la comida especial del supermercado o los
sobrados de la cocina, porque Máicol está enfermo y quiero que se
alivie. El problema es que sólo puedo probar una de las dos opciones, no
las dos al mismo tiempo:

-   Si le doy la comida del supermercado, ¿cómo sé qué habría pasado si
    le hubiera dado los sobrados?
-   Si le doy los sobrados, ¿cómo se qué habría pasado si le hubiera
    dado la comida del supermercado?

Esto es importante porque si no sé qué habría pasado en el caso
contrario, no puedo saber cuál de las dos opciones era la mejor. Quizás
le doy la comida del supermercado y Máicol se muere. ¿Significa eso que
la comida del supermercado es mala? ¿O será que si le hubiera dado los
sobrados se habría muerto de todas maneras?

Tengo dos opciones y sólo tengo un Máicol. ¿Qué hacer?

Los estadísticos, que son tan serios, me lanzan una propuesta
revolucionaria: clonar a Máicol usando una [lavadora
mágica](https://www.ted.com/talks/hans_rosling_and_the_magic_washing_machine/transcript).
Así tengo dos opciones y dos Máicoles:

![Dos Máicoles](imagenes/gato_clonado.png?raw=true "Dos Máicoles")

Puedo, entonces, probar la comida del supermercado en un Máicol y los
sobrados en el otro Máicol. Si por ejemplo el que comió comida del
supermercado murió y el que comió sobrados vivió, puedo concluir que los
sobrados son mejores que la comida del supermercado, porque los dos
Máicoles eran exactamente iguales, la única diferencia entre ellos fue
la comida que les di.

En los estudios sociales, ¿cuál es nuestra lavadora mágica? La
**aleatorización**:

![Dos
subpoblaciones](imagenes/gente_clonada.png?raw=true "Dos subpoblaciones")

Cuando hacemos un muestreo aleatorio garantizamos que **en promedio** la
muestra es igual a la población, es decir, que es representativa.
Podemos crear varias muestras aleatorias a partir de la misma población,
y por eso todas ellas, **en promedio** van a ser iguales unas a otras,
porque son todas iguales a la población. Y así es como se puede clonar
gente.

**Nota:** Para explicaciones adicionales por favor diríjase al profesor
disponible más cercano.

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
    de la población. En la evaluación sólo se consideró una muestra de
    cerca de 4000 personas, la mitad en grupo de tratamiento y la mitad
    en grupo de control.

-   **Ubicación geográfica:** Los jóvenes intervenidos habitaban en
    Barranquilla, Bogotá, Bucaramanga, Cali, Cartagena, Manizales o
    Medellín.

-   **Temporalidad:** El programa de educación se realizó entre 2002 y
    2006, pero la evaluación sólo tuvo en cuenta la cohorte de 2005.

-   **Intervención:** Tres meses de capacitación teórica y tres meses de
    prácticas no remuneradas (pero con auxilio de transporte).

-   **Investigadores:** Orazio Attanasio, Arlen Guarín, Adriana Kugler,
    Carlos Medina, Costas Meghir.

-   **Instituciones patrocinadoras:** DNP, Econometría S.A., SEI
    Consultores, Economic and Social Research Council, Universidad de
    Houston.

-   **Forma de aleatorización:** Se les instruyó a las 114 instituciones
    educativas participantes que hicieran una lista de estudiantes
    elegibles, con la condición de que el número de personas en la lista
    fuera mayor a la cantidad de personas que podrían recibir en los
    cursos de capacitación. Así, por ejemplo, una institución con
    capacidad para 100 estudiantes haría una lista de 150.
    Posteriormente se hizo un sorteo (una *aleatorización*) entre los
    aspirantes para determinar quiénes entrarían a los cursos (grupo de
    tratamiento) y quiénes no (grupo de control).

-   **Resultados principales:** El estudio mostró un impacto positivo de
    la capacitación en los ingresos y la empleabilidad formal de las
    mujeres, y evidenció que la intervención es más costo-efectiva que
    intervenciones similares en países desarrollados.

Los datos
---------

Los datos que usaremos en este tutorial se encuentran en este
[link](https://www.aeaweb.org/articles?id=10.1257/app.3.3.188).

El diccionario de variables puede ser consultado dentro de la carpeta
`datos`, en el archivo `AEJApp-20090168_readme.pdf`.

El software
-----------

El programa informático que los investigadores utilizaron para hacer el
estudio se llama [STATA](https://www.stata.com/), pero nosotros usaremos
una herramienta diferente, llamada [R](https://www.r-project.org/). En
teoría, los resultados deben ser siempre los mismos aunque se use
software diferente, pero suele pasar que hay pequeñas diferencias debido
a que cada software implementa las fórmulas matemáticas de manera
ligeramente distinta en la arquitectura de sus algoritmos.

Contenido
---------

1.  [Preliminares](preliminares.md)
2.  [Exploración inicial de los datos](exploracion.md)
3.  [Estadísticas descriptivas en línea de base](tabla2.md)
4.  [Tabla de balance](tabla3.md)
5.  [Tabla de resultados](tablaresultados.md)
