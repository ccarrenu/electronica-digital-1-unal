module testbench;
    // Declaraciones de señales
    reg clk;
    reg reset;
    reg sensor_izquierdo;
    reg sensor_derecho;
    wire ENA;
    wire IN1;
    wire ENB;
    wire IN3;

    // Instancia del diseño
    seguidor_linea uut (
        .clk(clk),
        .reset(reset),
        .sensor_derecho(sensor_derecho),
        .sensor_izquierdo(sensor_izquierdo),
        .ENA(ENA),
        .IN1(IN1),
        .ENB(ENB),
        .IN3(IN3)
    );

    // Inicialización
    initial begin
        clk = 0;
        reset = 1;
        sensor_izquierdo = 0;
        sensor_derecho = 0;
    end

    // Proceso de simulación
    always #10 clk = !clk; // Reloj de 10 MHz

    // Estímulos de entrada
    initial begin
        // Simulación de reset
        #10 reset = 0;

        // Simulación de sensores
        #20 sensor_izquierdo = 1;
        #40 sensor_derecho = 1;
        #60 sensor_izquierdo = 0;
        #80 sensor_derecho = 0;

        // Repetir estímulos
        #100 reset = 1;
    end

    // Verificación de salida
    always @(posedge clk) begin
        if (ENA !== 1'b0 || IN1 !== 1'b0 || ENB !== 1'b0 || IN3 !== 1'b0) begin
            $display("Error en la salida");
            $stop;
        end
    end
endmodule
