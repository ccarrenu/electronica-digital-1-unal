module top(
    input wire clk,
    input wire reset,
    input wire sensor_derecho,  // Sensor que detecta la línea en el lado derecho
    input wire sensor_izquierdo, // Sensor que detecta la línea en el lado izquierdo
    output wire ENA,              // Control de velocidad (PWM) para el motor izquierdo
    output wire IN1,              // Dirección para el motor izquierdo
    output wire ENB,              // Control de velocidad (PWM) para el motor derecho
    output wire IN3              // Dirección para el motor derecho
  
);

  // Instancias de los módulos
  seguidor_linea seguidor_linea_inst(
    .clk(clk),
    .reset(reset),
    .sensor_derecho(sensor_derecho),
    .sensor_izquierdo(sensor_izquierdo),
    .ENA(ENA),
    .IN1(IN1),
    .IN3(IN3),
    .ENB(ENB)
  );

  /*seguidor_linea_tb seguidor_linea_tb_inst (
    // Testbench clock and reset (might have different names in your code)
    .clk(clk),
    .reset(reset),
    // Testbench generated sensor value
    .sensor(sensor),
    // Testbench doesn't connect to motor outputs directly
    .motor_izq(motor_izq),
    .motor_der(motor_der)
  );*/
  
 endmodule
