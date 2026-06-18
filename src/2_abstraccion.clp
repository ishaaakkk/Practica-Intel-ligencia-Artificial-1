;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 2. MÓDULO DE ABSTRACCIÓN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmodule ABSTRACCION
   (import INPUT ?ALL)
   (export ?ALL)
)
   
   
   (defrule asignar-servicios-segun-distancia
      ?v <- (object (is-a Vivienda) (coordX ?vx)  (coordY ?vy)
                  (cerca_de $?c) (media_de $?m) (lejos_de $?l))
      ?s <- (object (is-a Servicio) (tipo ?tipo) (coordX ?sx) (coordY ?sy))
      (not (distancia-servicio-calculada ?v ?s))
      =>
      ;; Calcular distancia euclidiana
      (assert (distancia-servicio-calculada ?v ?s))

      (bind ?dist (calcDistanciaEuclidiana ?vx ?vy ?sx ?sy))

      ;; Clasificar según distancia
      (if (< ?dist 500) then
         ;; Insertar el tipo en cerca_de si no está ya
         (if (not (member$ ?s ?c)) then
            (slot-insert$ ?v cerca_de (+ (length$ ?c) 1) ?s)
         )
      else 
         (if (and (>= ?dist 500) (<= ?dist 1000)) then
            (if (not (member$ ?s ?m)) then
                  (slot-insert$ ?v media_de (+ (length$ ?m) 1) ?s)
            )
         else 
            (if (not (member$ ?s ?l)) then
                  (slot-insert$ ?v lejos_de (+ (length$ ?l) 1) ?s)
            )
         )
      )
   )



;; --- REGLAS DE ABSTRACCIÓN PARA VIVIENDAS ---

(defrule abstraccion-vivienda-precio
   ?v <- (object (is-a Vivienda) (precio ?p) (precio-cat nil))
   =>
   (bind ?cp (if (< ?p 1000) then bajo else (if (< ?p 1700) then medio else alto)))
   (send ?v put-precio-cat ?cp))

(defrule abstraccion-vivienda-tamano
   ?v <- (object (is-a Vivienda) (habitaciones ?h) (tamano-cat nil))
   =>
   (bind ?ct (if (< ?h 2) then pequeño else (if (<= ?h 3) then medio else grande)))
   (send ?v put-tamano-cat ?ct))

(defrule abstraccion-vivienda-superficie
   ?v <- (object (is-a Vivienda) (superficie ?s) (superficie-cat nil))
   =>
   (bind ?cs (if (< ?s 50) then pequeña else (if (< ?s 90) then mediana else grande)))
   (send ?v put-superficie-cat ?cs))

(defrule abstraccion-vivienda-fecha
   ?v <- (object (is-a Vivienda) (fechaEdificacion ?anio-val) (fechaEdificacion_Abs nil))
   =>
   (bind ?actual 2025)
   (bind ?edad (- ?actual ?anio-val))
   (bind ?anioAbs (if (< ?edad 6) then reciente else (if (< ?edad 20) then moderna else antigua)))
   (send ?v put-fechaEdificacion_Abs ?anioAbs))

(defrule abstraccion-vivienda-ascensor
   ?v <- (object (is-a Vivienda) (ascensor ?val) (ascensor_Abs nil))
   => (send ?v put-ascensor_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-vivienda-mascotas
   ?v <- (object (is-a Vivienda) (mascotasPermitidas ?val) (mascotasPermitidas_Abs nil))
   => (send ?v put-mascotasPermitidas_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-vivienda-amueblado
   ?v <- (object (is-a Vivienda) (amueblado ?val) (amueblado_Abs nil))
   => (send ?v put-amueblado_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-vivienda-piscina
   ?v <- (object (is-a Vivienda) (piscina ?val) (piscina_Abs nil))
   => (send ?v put-piscina_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-vivienda-aire
   ?v <- (object (is-a Vivienda) (aire_acondicionado ?val) (aire_acondicionado_Abs nil))
   => (send ?v put-aire_acondicionado_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-vivienda-calefaccion
   ?v <- (object (is-a Vivienda) (calefaccion ?val) (calefaccion_Abs nil))
   => (send ?v put-calefaccion_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-vivienda-garaje
   ?v <- (object (is-a Vivienda) (garaje ?val) (garaje_Abs nil))
   => (send ?v put-garaje_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-vivienda-vistas
   ?v <- (object (is-a Vivienda) (buenas_vistas ?val) (buenas_vistas_Abs nil))
   => (send ?v put-buenas_vistas_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-vivienda-terraza
   ?v <- (object (is-a Vivienda) (terraza ?val) (terraza_Abs nil))
   => (send ?v put-terraza_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-vivienda-balcon
   ?v <- (object (is-a Vivienda) (balcon ?val) (balcon_Abs nil))
   => (send ?v put-balcon_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-vivienda-soleado
   ?v <- (object (is-a Vivienda) (soleado ?val) (soleado_Abs nil))
   => (send ?v put-soleado_Abs (if (eq ?val yes) then TRUE else FALSE)))

;; --- REGLAS DE ABSTRACCIÓN PARA SOLICITANTES ---

(defrule abstraccion-solicitante-precio
   ?s <- (object (is-a Solicitante) (precioMax ?p&:(> ?p 0)) (precio-cat nil))
   =>
   (bind ?cp (if (< ?p 1000) then bajo else (if (< ?p 1700) then medio else alto)))
   (send ?s put-precio-cat ?cp))

(defrule abstraccion-solicitante-tamano
   ?s <- (object (is-a Solicitante) (numHabitaciones ?h&:(> ?h 0)) (tamano-cat nil))
   =>
   (bind ?ct (if (< ?h 2) then pequeño else (if (<= ?h 3) then medio else grande)))
   (send ?s put-tamano-cat ?ct))

(defrule abstraccion-solicitante-edad
   ?s <- (object (is-a Solicitante) (edad ?e&:(> ?e 0)) (edad-cat nil))
   =>
   (bind ?ce (if (< ?e 30) then joven else (if (< ?e 65) then adulto else anciano)))
   (send ?s put-edad-cat ?ce))

(defrule abstraccion-solicitante-ascensor
   ?s <- (object (is-a Solicitante) (ascensor ?val) (ascensor_Abs nil))
   => (send ?s put-ascensor_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-solicitante-mascotas
   ?s <- (object (is-a Solicitante) (mascotas ?val) (mascotas_Abs nil))
   => (send ?s put-mascotas_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-solicitante-amueblado
   ?s <- (object (is-a Solicitante) (amueblado ?val) (amueblado_Abs nil))
   => (send ?s put-amueblado_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-solicitante-piscina
   ?s <- (object (is-a Solicitante) (piscina ?val) (piscina_Abs nil))
   => (send ?s put-piscina_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-solicitante-aire
   ?s <- (object (is-a Solicitante) (aire_acondicionado ?val) (aire_acondicionado_Abs nil))
   => (send ?s put-aire_acondicionado_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-solicitante-calefaccion
   ?s <- (object (is-a Solicitante) (calefaccion ?val) (calefaccion_Abs nil))
   => (send ?s put-calefaccion_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-solicitante-garaje
   ?s <- (object (is-a Solicitante) (garaje ?val) (garaje_Abs nil))
   => (send ?s put-garaje_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-solicitante-vistas
   ?s <- (object (is-a Solicitante) (buenas_vistas ?val) (buenas_vistas_Abs nil))
   => (send ?s put-buenas_vistas_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-solicitante-terraza
   ?s <- (object (is-a Solicitante) (terraza ?val) (terraza_Abs nil))
   => (send ?s put-terraza_Abs (if (eq ?val yes) then TRUE else FALSE)))

(defrule abstraccion-solicitante-balcon
   ?s <- (object (is-a Solicitante) (balcon ?val) (balcon_Abs nil))
   => (send ?s put-balcon_Abs (if (eq ?val yes) then TRUE else FALSE)))

   (defrule abstraccion-pisos
      ?v <- (object (is-a ViviendaVertical))
      =>
      (bind ?planta (send ?v get-planta))

      ;; Calcular la categoría de altura
      (bind ?altura (if (<= ?planta 1)
            then baja
            else (if (<= ?planta 4) then media else alta)))

      ;; Guardar atributo abstracto
      (send ?v put-planta_Abs ?altura)
   )




