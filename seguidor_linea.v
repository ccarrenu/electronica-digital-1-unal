module seguidor_linea(
    input wire clk,
    input wire reset,
    input wire sensor_derecho,
    input wire sensor_izquierdo,
    output reg ENA,
    output reg IN1,
    output reg ENB,
    output reg IN3
);

parameter VELOCIDAD_CONSTANTE = 8'd200;
reg [7:0] contador_pwm;
parameter ESTADO_SOBRE_LINEA = 1'b1;
parameter ESTADO_FUERA_LINEA = 1'b0;
reg estado_actual;

always @(posedge clk) begin
    if (reset) begin
        estado_actual <= ESTADO_FUERA_LINEA;
        ENA <= 1'b0;
        ENB <= 1'b0;
        IN1 <= 1'b0;
        IN3 <= 1'b0;
        contador_pwm <= 8'd0;
    end else begin
        if (contador_pwm < 8'd255) begin
            contador_pwm <= contador_pwm + 1;
        end else begin
            contador_pwm <= 8'd0;
        end

        case (estado_actual)
            ESTADO_SOBRE_LINEA: begin
                if (!(sensor_derecho || sensor_izquierdo)) begin
                    estado_actual <= ESTADO_FUERA_LINEA;
                end
                ENA <= (contador_pwm < VELOCIDAD_CONSTANTE) ? 1'b1 : 1'b0;
                ENB <= (contador_pwm < VELOCIDAD_CONSTANTE) ? 1'b1 : 1'b0;
                IN1 <= 1'b1;
                IN3 <= 1'b1;
            end
            ESTADO_FUERA_LINEA: begin
                if (sensor_derecho && sensor_izquierdo) begin
                    estado_actual <= ESTADO_SOBRE_LINEA;
                end else if (sensor_derecho) begin
                    ENA <= (contador_pwm < VELOCIDAD_CONSTANTE) ? 1'b1 : 1'b0;
                    ENB <= (contador_pwm < VELOCIDAD_CONSTANTE) ? 1'b1 : 1'b0;
                    IN1 <= 1'b1;
                    IN3 <= 1'b0;
                end else if (sensor_izquierdo) begin
                    ENA <= (contador_pwm < VELOCIDAD_CONSTANTE) ? 1'b1 : 1'b0;
                    ENB <= (contador_pwm < VELOCIDAD_CONSTANTE) ? 1'b1 : 1'b0;
                    IN1 <= 1'b0;
                    IN3 <= 1'b1;
                end else begin
                    ENA <= 1'b0;
                    ENB <= 1'b0;
                    IN1 <= 1'b0;
                    IN3 <= 1'b0;
                end
            end
        endcase
    end
end

endmodule
