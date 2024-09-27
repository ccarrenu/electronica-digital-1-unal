# Seguidor de Línea en FPGA (BlackIce40) con compuertas lógicas

Nuestro proyecto consiste en la implementación de un seguidor de línea utilizando una FPGA BlackIce40, diseñado con compuertas lógicas. El sistema diseñado controla dos motores utilizando un driver L298N, el modulo de sensores TCRT5000 para la detección de la línea y un sensor de proximidad ultrasónico para evitar obstáculos. El sistema es alimentado por una batería de litio y un módulo powerbank. Fue diseñado en verilog y comprobado GTKwave.

## Componentes Utilizados
- **FPGA BlackIce40**: Utilizada para controlar la lógica de todo el sistema y cargar el codigo encargado del funcionamiento del seguidor de linea.
- **Módulo TCRT5000**: Sensor optico reflexivo que consta de un emisor de luz infrarroja también llamado fotodiodo y un fototransistor. El fototransistor detecta la luz que es reflejada cuando un objeto pasa enfrente del sensor por lo que sirve para la detección de líneas en el suelo.
- **Sensor de proximidad ultrasónico HC-SR05**: El HC-SR05 es un sensor de distancias por ultrasonidos capaz de detectar objetos y calcular la distancia a la que se encuentra en un rango de 2 a 450 cm. El sensor funciona por ultrasonidos y contiene toda la electrónica encargada de hacer la medición. Para la detección de obstáculos y prevención de colisiones.
- **Driver L298N**: El driver L298N es un dispositivo que permite controlar el sentido de funcionamiento de motores a una corriente de salida por canal de hasta 2A, internamente posee dos puentes H completos que permiten controlar 2 motores DC. El módulo permite controlar el sentido y velocidad de giro de motores mediante señales TTL. El control del sentido de giro se realiza mediante dos pines para cada motor, la velocidad de giro se puede regular haciendo uso de modulación por ancho de pulso.
- **Motores motorreductores**:  Es un motor al que se le acopla un juego de engranes. Estos sirven para cambiar algunas de las características más importantes, como lo son la velocidad y la fuerza de salida. En el proyecto se utilizan dos motores que permiten el movimiento del vehículo.
- **Chasis**: Base en acrilico donde se montan los componentes, posee tres llantas que permiten el desplazamiento.
- **Batería de litio**: Tipo de batería recargable que utiliza compuestos de litio como uno de los electrodos. Es la fuente de alimentación del sistema.
- **Módulo Powerbank**: Es un chip encapsulado en formato SOP-8 que es capaz de gestionar la carga de una batería. Permite conectarle una fuente de energía eléctrica a su entrada y una batería a su salida para que pueda cargarse de forma adecuada. 


## Proceso de ideación
La idea del proyecto nació con el propósito de combinar las áreas de electrónica digital y control mecánico, utilizando una FPGA para implementar la lógica de control sin recurrir a microcontroladores. La decisión de usar una FPGA BlackIce40 en lugar de microcontroladores o plataformas más comunes como Arduino estuvo motivada por la necesidad de un mayor control sobre los circuitos lógicos, la flexibilidad en la programación de compuertas lógicas y la posibilidad de optimizar el comportamiento en tiempo real, ademas que fue la plataforma trabajada durante todo el semestre.

Otro aspecto clave en la ideación fue la selección de los sensores y actuadores que mejor se adecuaran al propósito del proyecto. Tras investigar las diferentes alternativas, los componentes elegidos fueron:

- **Módulo TCRT5000:** Este sensor infrarrojo fue seleccionado por su capacidad para detectar variaciones de color en el suelo, lo que lo hace ideal para la detección de líneas blancas o negras sobre distintas superficies.
- **Driver L298N:** El controlador de motores L298N fue seleccionado por su compatibilidad con las señales de control digitales provenientes de la FPGA y su capacidad para manejar la potencia de los motores utilizados.

### Objetivos planteados
Desde el inicio se establecieron los siguientes objetivos:
- **Seguidor de línea funcional:** El sistema debía ser capaz de seguir una línea negra o blanca en un fondo contrastante utilizando sensores infrarrojos..
- **Control preciso de los motores:** Usar la FPGA para generar señales PWM que permitieran controlar la velocidad y dirección de los motores motorreductores.
- **Simplicidad y eficiencia en el diseño lógico:** Minimizar el uso de recursos lógicos en la FPGA, empleando un diseño que fuera eficiente en el uso de compuertas y registros.

### Planificación del diseño final
Finalmente, el diseño se estructuró en módulos de lógica combinacional para gestionar la lectura de los sensores, el control de los motores y la toma de decisiones del sistema:
- **Lógica de detección de línea:** Un módulo se encarga de procesar las señales del sensor TCRT5000, determinando si el vehículo está sobre la línea o se ha desviado.
- **Control de motores:** Basado en las señales del sensor, se genera una señal PWM para el driver L298N, ajustando la dirección y velocidad de los motores.

### Prototipado
Antes de implementar la lógica en la FPGA, se realizó un prototipo en simuladores digitales para validar el comportamiento de los diferentes módulos lógicos. Esto permitió detectar posibles errores en el diseño y realizar ajustes previos a la implementación física.

## Diseño
El diseño del seguidor de línea con FPGA se dividió en diferentes subsistemas que trabajan en conjunto para lograr el objetivo de seguir una línea. Cada componente del sistema fue seleccionado cuidadosamente para garantizar compatibilidad y funcionalidad eficiente en el contexto de un control basado en lógica combinacional en la FPGA BlackIce40. 

### Arquitectura general
El sistema se estructuró en dos bloques principales:

1. * *Bloque de detección de línea:* * Se encarga de procesar las señales del sensor TCRT5000 y decidir la dirección del vehículo.
2. * *Bloque de control de motores:* * Utiliza las señales generadas por el bloque de detección de línea para activar los motores a través del driver L298N.

### Bloque de detección de línea
El sensor TCRT5000 es un módulo infrarrojo que detecta la presencia de una línea oscura sobre un fondo claro o viceversa. La idea es que este sensor emite un rayo de luz infrarroja hacia el suelo y mide el nivel de reflexión. Si detecta una superficie clara (como una línea blanca en un fondo oscuro), la reflexión será mayor, mientras que una línea negra reflejará menos luz.

- **Lógica de funcionamiento:**
	- Entrada: Señal analógica del sensor TCRT5000.
	- Conversión: La señal analógica se convierte en una señal digital mediante un comparador simple en la FPGA, donde se asigna un umbral para determinar si el sensor está sobre la línea.
	- Salida: La lógica combinacional genera dos señales de salida que indican si el vehículo está centrado, desviado hacia la izquierda o la derecha respecto a la línea. Estas señales se utilizan para activar los motores de forma adecuada.
- **Estructura:**
	- Comparadores: Implementados en la FPGA para interpretar la señal del sensor.
	- Decisión binaria: La lógica analiza si el valor del sensor es mayor o menor que el umbral y decide si el vehículo debe girar o mantener su curso.
- **Comportamiento:**
	1. Si ambos sensores (izquierdo y derecho) están sobre la línea, el vehículo se mantiene recto.
	2. Si el sensor derecho detecta la línea pero el izquierdo no, el vehículo gira hacia la izquierda.
	3. Si el sensor izquierdo detecta la línea pero el derecho no, el vehículo gira hacia la derecha.
	4. Si ninguno de los sensores detecta la línea, el vehículo se detiene para evitar que salga del recorrido.

### Bloque de control de motores
Los motores son controlados a través del driver L298N, que permite manejar dos motores de corriente continua (motorreductores). Este driver es ideal para controlar la dirección y velocidad de los motores mediante señales de control digitales generadas por la FPGA.

- **Lógica de control:**
	- Entradas: Señales digitales generadas por la lógica de detección de línea.
	- PWM (Pulse Width Modulation): Se utiliza la modulación por ancho de pulso para controlar la velocidad de los motores. Las señales PWM se generan directamente en la FPGA, controlando la duración de los pulsos enviados al L298N. Son dos senales binarias, ENA para el motor izquierdo y ENB para el motor derecho.
	- Dirección: Dos señales binarias (IN1 y IN2) controlan la dirección de rotación de los motores. Si ambas señales están en alto, el motor avanza. Si están en bajo, el motor se detiene.
- **Comportamiento:**
	- Recto: Ambos motores giran en la misma dirección y velocidad.
	- Giro a la derecha: El motor izquierdo se detiene mientras el motor derecho sigue girando, haciendo que el vehículo gire.
	- Giro a la izquierda: El motor derecho se detiene mientras el motor izquierdo sigue girando.
	- Parada: Ambos motores se detienen si no se detecta la línea.


### Alimentación
El sistema se alimenta utilizando una batería de litio conectada a un módulo powerbank, lo cual garantiza una fuente de energía estable para todos los componentes, incluyendo la FPGA, el driver de motores y los sensores.

- **Distribución de energía:**
	- FPGA: La FPGA recibe energía directamente desde el powerbank.
	- Motores y driver: Los motores estan conectados a el driver L298N. Y este a su vez esta conectado a una fiente DC variable dado que requieren un voltaje mayor para su operación.
La utilización de un módulo powerbank asegura que la alimentación sea continua y que la FPGA tenga protección contra picos de voltaje o caídas inesperadas de corriente.

### Integración de los módulos
Una vez diseñados los bloques por separado, se integraron en la FPGA mediante la conexión de sus respectivas señales de entrada y salida, mediante cables y resistencias. La lógica se organizó para que los dos bloques principales (detección de línea y control de motore) interactuaran sin conflictos.

### Sincronización y temporización:
- Reloj del sistema: La FPGA utiliza un reloj interno para sincronizar las operaciones de los distintos módulos.
- Tiempos de respuesta: Se ajustaron los tiempos de respuesta de los sensores y motores para evitar latencias que afectaran el rendimiento del vehículo.

### Simulación y pruebas
Antes de la implementación física, cada módulo fue simulado por separado para garantizar que las señales generadas fueran las correctas. Posteriormente, se realizaron simulaciones completas del sistema integrado para verificar que las señales entre los módulos estuvieran correctamente sincronizadas y que los motores respondieran adecuadamente a las entradas de los sensores.



## Implementación
La implementación del seguidor de línea basado en la FPGA BlackIce fue realizada en varias etapas, comenzando con la integración de los componentes físicos, el desarrollo de la lógica en la FPGA y la realización de pruebas para garantizar que el sistema cumpliera con los requisitos de seguimiento de línea y evitación de obstáculos. A continuación, se detalla cada paso del proceso de implementación.

1. **Montaje del Hardware:**
1.1. Sensores TCRT5000: El primer paso fue la instalación de los sensores TCRT5000, responsables de detectar la línea. Estos sensores se montaron en la parte inferior del chasis del vehículo para que pudieran detectar la línea en el suelo.
- Posición del sensor: Los sensores se colocaron de manera que estuvieran equidistantes de la línea central del vehículo, permitiendo detectar tanto desviaciones hacia la izquierda como hacia la derecha.
- Conexión: Los sensores fueron conectados directamente a los pines de entrada de la FPGA. Las señales analógicas de salida del TCRT5000 se convirtieron en digitales usando comparadores dentro de la FPGA, con un umbral de detección para distinguir entre una superficie oscura y clara.

1.2. Motores y Driver L298N: Los dos motores motorreductores son controlados por el driver L298N, que permite gestionar tanto la velocidad como la dirección de los motores. 
- Conexión del driver: El L298N fue conectado a la FPGA para recibir las señales PWM y las señales de control de dirección (in1, in2) que determinan el giro de los motores. Además, el L298N se conectó directamente a la batería de litio para obtener la potencia necesaria.
- Control de velocidad: La FPGA genera señales PWM de distinta duración para controlar la velocidad de los motores. Al variar el ciclo de trabajo del PWM, se puede ajustar la velocidad de los motores.
- Control de dirección: A través de las señales de control, el L298N puede cambiar la dirección de rotación de los motores, lo que permite que el vehículo gire hacia la izquierda o la derecha.

1.3 Chasis y Alimentación: El chasis del vehículo fue diseñado para soportar todos los componentes, incluyendo la FPGA, los motores, los sensores y la batería.
- Chasis: Se utilizó un chasis de seguidor estándar con soportes para los motores y espacio para la batería y la FPGA. Se aseguró que el chasis permitiera una fácil disposición de los componentes y un montaje estable para evitar vibraciones que pudieran interferir con los sensores.
- Alimentación: La batería de litio se conectó a el driver de los motores. Y los demas componentes al driver.


2. **Desarrollo del firmware en la FPGA:**
2.1. Desarrollo de la lógica de detección de línea: La lógica de detección de línea fue implementada utilizando compuertas lógicas en la FPGA. Para ello, se escribió el código en Verilog, que define la interacción entre las señales de entrada de los sensores y las señales de salida hacia los motores.

- Conversión de señales: Las señales analógicas del sensor TCRT5000 fueron procesadas por un comparador implementado en la FPGA para generar una señal digital (0 o 1) que indique si se detecta la línea o no.
- Decisiones lógicas: Se implementó una lógica simple para determinar el comportamiento de los motores:
	- Si ambos sensores detectan la línea (señales 1 y 1), los motores avanzan.
	- Si solo el sensor derecho detecta la línea (0 y 1), el motor izquierdo acelera y el derecho desacelera para girar a la izquierda.
	- Si solo el sensor izquierdo detecta la línea (1 y 0), el motor derecho acelera y el izquierdo desacelera para girar a la derecha.
	- Si ningún sensor detecta la línea (0 y 0), ambos motores se detienen.
2.2. Generación de PWM para control de motores: El control de velocidad de los motores fue implementado utilizando señales PWM generadas directamente en la FPGA.
	- Ciclo de trabajo: El ciclo de trabajo del PWM fue ajustado para controlar la velocidad de los motores. Un ciclo de trabajo del 50% permitió que los motores giraran a velocidad media, mientras que ciclos más altos aumentaron la velocidad.
	- Señales de control: Las señales in1 e in2 del driver L298N fueron gestionadas por la FPGA para controlar la dirección de los motores. Combinando estas señales, se puede lograr tanto movimiento hacia adelante como hacia atrás.


3. **Integración de módulos:**
Una vez que los módulos de detección de línea y control de motores fueron implementados por separado, se integraron en el diseño general del sistema. Esta integración permitió que el vehículo pudiera manejar las dos funcionalidades (seguir la línea y controlar la velocidad/dirección de los motores) de manera simultánea. La lógica fue probada en simulaciones utilizando herramientas de simulación de FPGA, verificando que todas las señales estuvieran correctamente sincronizadas y que los módulos interactuaran sin problemas.

 ## Referencias
 - Información Modulo TCRT5000: https://ferretronica.com/products/modulo-tcrt5000-sensor-infrarrojo-seguidor-de-linea?srsltid=AfmBOorXsOP5AKXPBsDTUPDRSAG_Bm-GB7WUulcOhOpGDPhr1Ufduubi
 - Información Modulo L298: https://naylampmechatronics.com/blog/11_tutorial-de-uso-del-modulo-l298n.html
 - Información bateria IonLitio: https://www.iberdrola.com/innovacion/baterias-ion-litio
 - Información motorreductor: https://www.ingmecafenix.com/automatizacion/motores-industriales/motorreductor/
 - Información del modulo de carga y descarga: https://www.ingmecafenix.com/automatizacion/motores-industriales/motorreductor/



