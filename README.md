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


## Proceso de Ideación
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

