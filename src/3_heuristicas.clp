;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3. MÓDULO DE ASOCIACIONES HEURÍSTICAS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmodule HEURISTICAS
   (import INPUT ?ALL)
   (import ABSTRACCION ?ALL)
   (export ?ALL)
)

;; --- REGLAS DE ASOCIACIÓN HEURÍSTICA ---

;; Evaluar Precio  (precio-cat)
(defrule asociar-heuristica-precio
   ?s <- (object (is-a Solicitante) (precio-cat ?spc))
   ?v <- (object (is-a Vivienda) (precio-cat ?vpc) (requisitos-fallados $?fallos) (ventajas-extra $?extras))
   =>
   ;; Es un fallo si el precio de la vivienda es de una categoría superior a la del solicitante
   (if (and (eq ?spc medio) (eq ?vpc alto)) then
      (if (not (member$ precio-excedido ?fallos)) then (slot-insert$ ?v requisitos-fallados 1 precio-excedido)))
   (if (and (eq ?spc bajo) (or (eq ?vpc medio) (eq ?vpc alto))) then
      (if (not (member$ precio-excedido ?fallos)) then (slot-insert$ ?v requisitos-fallados 1 precio-excedido)))

   ;; es una ventaja/extra si el precio de la vivienda es de una categoría inferior
   (if (and (eq ?spc alto) (or (eq ?vpc medio) (eq ?vpc bajo))) then
      (if (not (member$ precio-ventajoso ?extras)) then (slot-insert$ ?v ventajas-extra 1 precio-ventajoso)))
   (if (and (eq ?spc medio) (eq ?vpc bajo)) then
      (if (not (member$ precio-ventajoso ?extras)) then (slot-insert$ ?v ventajas-extra 1 precio-ventajoso)))
)

;; Evaluar Habitaciones  (tamano-cat)
(defrule asociar-heuristica-habitaciones
   ;; solo se activa si el usuario ha pedido un número de habitaciones > 0 para que no se active si el usuario no ha indicado com restriccion el numero de habitaciones
   ?s <- (object (is-a Solicitante) (numHabitaciones ?h&:(> ?h 0)) (tamano-cat ?stc))
   ?v <- (object (is-a Vivienda) (tamano-cat ?vtc) (requisitos-fallados $?fallos) (ventajas-extra $?extras))
   =>
   ;; Falla si el tamaño de la vivienda es de una categoría inferior
   (if (and (eq ?stc medio) (eq ?vtc pequeño)) then
      (if (not (member$ habitaciones-insuficientes ?fallos)) then (slot-insert$ ?v requisitos-fallados 1 habitaciones-insuficientes)))
   (if (and (eq ?stc grande) (or (eq ?vtc medio) (eq ?vtc pequeño))) then
      (if (not (member$ habitaciones-insuficientes ?fallos)) then (slot-insert$ ?v requisitos-fallados 1 habitaciones-insuficientes)))

   ;; Ventaja si el tamaño de la vivienda es de una categoría superior
   (if (and (eq ?stc pequeño) (or (eq ?vtc medio) (eq ?vtc grande))) then
      (if (not (member$ habitaciones-extra ?extras)) then (slot-insert$ ?v ventajas-extra 1 habitaciones-extra)))
   (if (and (eq ?stc medio) (eq ?vtc grande)) then
      (if (not (member$ habitaciones-extra ?extras)) then (slot-insert$ ?v ventajas-extra 1 habitaciones-extra)))
)


;;   REGLAS DE ASOCIACIÓN HEURÍSTICA PARA RESTRICCIONES BOOLEANAS
;; cada regla comprueba una única restricción 

(defrule asociar-heuristica-ascensor
   (object (is-a Solicitante) (ascensor_Abs TRUE))
   ?v <- (object (is-a Vivienda) (ascensor_Abs FALSE) (requisitos-fallados $?f&:(not (member$ ascensor-faltante ?f))))
   =>
   (slot-insert$ ?v requisitos-fallados 1 ascensor-faltante))

(defrule asociar-heuristica-mascotas
   (object (is-a Solicitante) (mascotas_Abs TRUE))
   ?v <- (object (is-a Vivienda) (mascotasPermitidas_Abs FALSE) (requisitos-fallados $?f&:(not (member$ mascotas-no-permitidas ?f))))
   =>
   (slot-insert$ ?v requisitos-fallados 1 mascotas-no-permitidas))

(defrule asociar-heuristica-amueblado
   (object (is-a Solicitante) (amueblado_Abs TRUE))
   ?v <- (object (is-a Vivienda) (amueblado_Abs FALSE) (requisitos-fallados $?f&:(not (member$ no-amueblado ?f))))
   =>
   (slot-insert$ ?v requisitos-fallados 1 no-amueblado))

(defrule asociar-heuristica-piscina
   (object (is-a Solicitante) (piscina_Abs TRUE))
   ?v <- (object (is-a Vivienda) (piscina_Abs FALSE) (requisitos-fallados $?f&:(not (member$ piscina-faltante ?f))))
   =>
   (slot-insert$ ?v requisitos-fallados 1 piscina-faltante))

(defrule asociar-heuristica-aire-acondicionado
   (object (is-a Solicitante) (aire_acondicionado_Abs TRUE))
   ?v <- (object (is-a Vivienda) (aire_acondicionado_Abs FALSE) (requisitos-fallados $?f&:(not (member$ aire-faltante ?f))))
   =>
   (slot-insert$ ?v requisitos-fallados 1 aire-faltante))

(defrule asociar-heuristica-calefaccion
   (object (is-a Solicitante) (calefaccion_Abs TRUE))
   ?v <- (object (is-a Vivienda) (calefaccion_Abs FALSE) (requisitos-fallados $?f&:(not (member$ calefaccion-faltante ?f))))
   =>
   (slot-insert$ ?v requisitos-fallados 1 calefaccion-faltante))

(defrule asociar-heuristica-garaje
   (object (is-a Solicitante) (garaje_Abs TRUE))
   ?v <- (object (is-a Vivienda) (garaje_Abs FALSE) (requisitos-fallados $?f&:(not (member$ garaje-faltante ?f))))
   =>
   (slot-insert$ ?v requisitos-fallados 1 garaje-faltante))

(defrule asociar-heuristica-buenas-vistas
   (object (is-a Solicitante) (buenas_vistas_Abs TRUE))
   ?v <- (object (is-a Vivienda) (buenas_vistas_Abs FALSE) (requisitos-fallados $?f&:(not (member$ sin-buenas-vistas ?f))))
   =>
   (slot-insert$ ?v requisitos-fallados 1 sin-buenas-vistas))

(defrule asociar-heuristica-terraza
   (object (is-a Solicitante) (terraza_Abs TRUE))
   ?v <- (object (is-a Vivienda) (terraza_Abs FALSE) (requisitos-fallados $?f&:(not (member$ terraza-faltante ?f))))
   =>
   (slot-insert$ ?v requisitos-fallados 1 terraza-faltante))

(defrule asociar-heuristica-balcon
   (object (is-a Solicitante) (balcon_Abs TRUE))
   ?v <- (object (is-a Vivienda) (balcon_Abs FALSE) (requisitos-fallados $?f&:(not (member$ balcon-faltante ?f))))
   =>
   (slot-insert$ ?v requisitos-fallados 1 balcon-faltante))

;; REGLAS DE ASOCIACIÓN HEURÍSTICA PARA TIPO DE VIVIENDA

(defrule asociar-heuristica-tipo-vivienda-piso-incorrecto
   (object (is-a Solicitante) (tipoVivienda piso))
   ?v <- (object (is-a Vivienda) (requisitos-fallados $?f&:(not (member$ tipoVivienda-incorrecto ?f))))
   (test (eq (class ?v) Vivienda))
   =>
   (slot-insert$ ?v requisitos-fallados 1 tipoVivienda-incorrecto))

(defrule asociar-heuristica-tipo-vivienda-casa-incorrecta
   (object (is-a Solicitante) (tipoVivienda casa))
   ?v <- (object (is-a ViviendaVertical) (requisitos-fallados $?f&:(not (member$ tipoVivienda-incorrecto ?f))))
   =>
   (slot-insert$ ?v requisitos-fallados 1 tipoVivienda-incorrecto))

;; Evaluar ventajas extra no solicitadas (ejemplo soleado) 
(defrule asociar-heuristica-ventaja-soleado
   ?v <- (object (is-a Vivienda) (soleado_Abs TRUE) (ventajas-extra $?extras))
   =>
   (if (not (member$ soleado ?extras)) then
      (slot-insert$ ?v ventajas-extra 1 soleado)
   )         
)
(defrule asociar-heuristica-ventaja-planta-deseada
    ?s <- (object (is-a Solicitante)
                      (tipoVivienda ?tipoDeseado)
                      (altura-cat ?plantaSolicitada))
    ?v <- (object (is-a ViviendaVertical)
                      (ventajas-extra $?extras)
                      (planta_Abs ?plantaReal))
    =>
    ;; Si la altura solicitada coincide con la real, marcar como ventaja (no como fallo)
    (if (eq ?plantaSolicitada ?plantaReal) then
        (if (not (member$ planta-deseada ?extras)) then
            (slot-insert$ ?v ventajas-extra 1 planta-deseada)))

)
(defrule asociar-heuristica-ventaja-reciente
   ?v <- (object (is-a Vivienda)
                 (fechaEdificacion_Abs reciente)
                 (ventajas-extra $?extras))
   =>
   (if (not (member$ reciente ?extras)) then
      (slot-insert$ ?v ventajas-extra 1 reciente)
   )
)
(defrule asociar-heuristica-ventaja-atico
   ?v <- (object (is-a ViviendaVertical) (atico yes) (ventajas-extra $?extras))
   =>
   (if (not (member$ atico ?extras)) then
      (slot-insert$ ?v ventajas-extra 1 atico)
   )
)

(defrule asociar-heuristica-ventaja-duplex
   ?v <- (object (is-a Duplex) (ventajas-extra $?extras))
   =>
   (if (not (member$ duplex ?extras)) then
      (slot-insert$ ?v ventajas-extra 1 duplex))
)

;; Evaluar preferencias de servicios como ventajas extra (coincidencia estricta)
(defrule asociar-heuristica-servicios
   ?s <- (object (is-a Solicitante) 
                  (cerca_de $?sc) 
                  (media_de $?sm)
                  (lejos_de $?sl))
   ?v <- (object (is-a Vivienda) 
                  (cerca_de $?servicios_cercanos) 
                  (media_de $?servicios_medios) 
                  (lejos_de $?servicios_lejanos)
                  (ventajas-extra $?extras))
   =>
   ;; 1. Añadir ventaja si un servicio preferido "cerca" está cerca
   (foreach ?tipo_req ?sc
      (bind ?encontrado_cerca FALSE)
      (foreach ?servicio_instancia ?servicios_cercanos
         (if (eq (send ?servicio_instancia get-tipo) ?tipo_req) then (bind ?encontrado_cerca TRUE) (break)))
      (if (eq ?encontrado_cerca TRUE) then
         (if (not (member$ (sym-cat servicio-cercano- ?tipo_req) ?extras)) then
            (slot-insert$ ?v ventajas-extra 1 (sym-cat servicio-cercano- ?tipo_req)))))
   
   ;; 2. Añadir ventaja si un servicio preferido a "media" distancia está a media distancia
   (foreach ?tipo_req ?sm
      (bind ?encontrado_media FALSE)
      (foreach ?servicio_instancia ?servicios_medios
         (if (eq (send ?servicio_instancia get-tipo) ?tipo_req) then (bind ?encontrado_media TRUE) (break)))
      (if (eq ?encontrado_media TRUE) then
         (if (not (member$ (sym-cat servicio-a-distancia-media- ?tipo_req) ?extras)) then
            (slot-insert$ ?v ventajas-extra 1 (sym-cat servicio-a-distancia-media- ?tipo_req)))))

   ;; 3. Añadir ventaja si un servicio preferido "lejos" está lejos
   (foreach ?tipo_req ?sl
      (bind ?encontrado_lejos FALSE)
      (foreach ?servicio_instancia ?servicios_lejanos
         (if (eq (send ?servicio_instancia get-tipo) ?tipo_req) then (bind ?encontrado_lejos TRUE) (break)))
      (if (eq ?encontrado_lejos TRUE) then
         (if (not (member$ (sym-cat servicio-lejano- ?tipo_req) ?extras)) then
            (slot-insert$ ?v ventajas-extra 1 (sym-cat servicio-lejano- ?tipo_req)))))
)

;Regla extra para solicitantes de tipo 'anciano'
;si el anciano no ha especificado preferencia por hospitales,
;se añade como ventaja extra si la vivienda está cerca de uno
(defrule asociar-heuristica-extra-hospital-anciano
   ;condición 1 El solicitante es 'anciano'
   ?s <- (object (is-a Solicitante)
                  (tipo_solicitante anciano)
                  ; y NO se ha especificado una preferencia por 'hospital'
                  (cerca_de $?c&:(not (member$ hospital ?c)))
                  (media_de $?m&:(not (member$ hospital ?m)))
                  (lejos_de $?l&:(not (member$ hospital ?l)))
         )
   ; condición 2 Existe una vivienda
   ?v <- (object (is-a Vivienda)
                  (cerca_de $?servicios_cercanos&:(hay-servicio-de-tipo hospital ?servicios_cercanos))
                  (ventajas-extra $?extras&:(not (member$ extra-hospital-cercano-anciano ?extras)))
         )
   =>
   (slot-insert$ ?v ventajas-extra 1 extra-hospital-cercano-anciano)
)

;Regla extra para solicitantes de tipo 'joven'
;si el joven no ha especificado preferencia por el centro,
;se añade como ventaja extra si la vivienda está cerca de el
(defrule asociar-heuristica-extra-centro-joven-declarativa
   (object (is-a Solicitante)
                  (tipo_solicitante joven)
                  (cerca_de $?c&:(not (member$ centro ?c)))
                  (media_de $?m&:(not (member$ centro ?m)))
                  (lejos_de $?l&:(not (member$ centro ?l)))
         )
   ?v <- (object (is-a Vivienda)
                  (cerca_de $?servicios_cercanos&:(hay-servicio-de-tipo centro ?servicios_cercanos))
                  (ventajas-extra $?extras&:(not (member$ extra-centro-cercano-joven ?extras)))
         )
   =>
   (slot-insert$ ?v ventajas-extra 1 extra-centro-cercano-joven)
)

;Regla extra para solicitantes de tipo 'joven'
;si el joven no ha especificado preferencia por el ocio nocturno,
;se añade como ventaja extra si la vivienda está cerca de el
(defrule asociar-heuristica-extra-ocio-nocturno-joven-declarativa
   (object (is-a Solicitante)
                  (tipo_solicitante joven)
                  (cerca_de $?c&:(not (member$ ocio_nocturno ?c)))
                  (media_de $?m&:(not (member$ ocio_nocturno ?m)))
                  (lejos_de $?l&:(not (member$ ocio_nocturno ?l)))
         )
   ?v <- (object (is-a Vivienda)
                  (cerca_de $?servicios_cercanos&:(hay-servicio-de-tipo ocio_nocturno ?servicios_cercanos))
                  (ventajas-extra $?extras&:(not (member$ extra-ocio-nocturno-cercano-joven ?extras)))
         )
   =>
   (slot-insert$ ?v ventajas-extra 1 extra-ocio-nocturno-cercano-joven)
)

;Regla extra para solicitantes de tipo 'pareja_con_hijos'
;si no han especificado preferencia por el centro_educativo,
;se añade como ventaja extra si la vivienda está a media distancia de uno
(defrule asociar-heuristica-extra-centro-educativo-media-familia-declarativa
   (object (is-a Solicitante)
                  (tipo_solicitante pareja_con_hijos)
                  (cerca_de $?c&:(not (member$ centro_educativo ?c)))
                  (media_de $?m&:(not (member$ centro_educativo ?m)))
                  (lejos_de $?l&:(not (member$ centro_educativo ?l)))
         )
   ?v <- (object (is-a Vivienda)
                  (media_de $?servicios_medios&:(hay-servicio-de-tipo centro_educativo ?servicios_medios))
                  (ventajas-extra $?extras&:(not (member$ extra-centro-educativo-media-familia ?extras)))
         )
   =>
   (slot-insert$ ?v ventajas-extra 1 extra-centro-educativo-media-familia)
)

;Regla extra para solicitantes de tipo 'movilidad_reducida'
;si no han especificado como restricción un ascensor,
;se añade como ventaja extra si la vivienda lo tiene.
(defrule asociar-heuristica-extra-ascensor-movilidad-reducida
   (object (is-a Solicitante)
                  (tipo_solicitante movilidad_reducida)
                  ;; El usuario no ha pedido ascensor como restricción
                  (ascensor_Abs FALSE)
         )
   ?v <- (object (is-a Vivienda)
                  (ascensor_Abs TRUE)
                  (ventajas-extra $?extras&:(not (member$ extra-ascensor-movilidad-reducida ?extras)))
         )
   =>
   (slot-insert$ ?v ventajas-extra 1 extra-ascensor-movilidad-reducida)
)

;Regla extra para solicitantes de tipo 'estudiante'
;si no han especificado preferencia por el centro_educativo,
;se añade como ventaja extra si la vivienda está cerca de uno
(defrule asociar-heuristica-extra-centro-educativo-estudiante-declarativa
   (object (is-a Solicitante)
                  (tipo_solicitante estudiante)
                  (cerca_de $?c&:(not (member$ centro_educativo ?c)))
                  (media_de $?m&:(not (member$ centro_educativo ?m)))
                  (lejos_de $?l&:(not (member$ centro_educativo ?l)))
         )
   ?v <- (object (is-a Vivienda)
                  (cerca_de $?servicios_cercanos&:(hay-servicio-de-tipo centro_educativo ?servicios_cercanos))
                  (ventajas-extra $?extras&:(not (member$ extra-centro-educativo-cercano-estudiante ?extras)))
         )
   =>
   (slot-insert$ ?v ventajas-extra 1 extra-centro-educativo-cercano-estudiante)
)

;Regla extra para solicitantes de tipo 'estudiante'
;si no han especificado preferencia por el transporte_publico,
;se añade como ventaja extra si la vivienda está cerca de uno
(defrule asociar-heuristica-extra-transporte-estudiante-declarativa
   (object (is-a Solicitante)
                  (tipo_solicitante estudiante)
                  (cerca_de $?c&:(not (member$ transporte_publico ?c)))
                  (media_de $?m&:(not (member$ transporte_publico ?m)))
                  (lejos_de $?l&:(not (member$ transporte_publico ?l)))
         )
   ?v <- (object (is-a Vivienda)
                  (cerca_de $?servicios_cercanos&:(hay-servicio-de-tipo transporte_publico ?servicios_cercanos))
                  (ventajas-extra $?extras&:(not (member$ extra-transporte-cercano-estudiante ?extras)))
         )
   =>
   (slot-insert$ ?v ventajas-extra 1 extra-transporte-cercano-estudiante)
)

;Regla extra para solicitantes sin coche
;si el solicitante no tiene coche,
;se añade como ventaja extra si la vivienda está cerca de transporte público
(defrule asociar-heuristica-extra-transporte-sinCoche
   (object (is-a Solicitante)
                  (coche no)
         )
   ?v <- (object (is-a Vivienda)
                  (cerca_de $?servicios_cercanos&:(hay-servicio-de-tipo transporte_publico ?servicios_cercanos))
                  (ventajas-extra $?extras&:(not (member$ extra-transporte-sinCoche ?extras)))
         )
   =>
   (slot-insert$ ?v ventajas-extra 1 extra-transporte-sinCoche)
)

;Regla extra para solicitantes de tipo 'soltero'
;si no han especificado preferencia por el ocio,
;se añade como ventaja extra si la vivienda está cerca de uno
(defrule asociar-heuristica-extra-ocio-soltero-declarativa
   (object (is-a Solicitante)
                  (tipo_solicitante soltero)
                  (cerca_de $?c&:(not (member$ ocio ?c)))
                  (media_de $?m&:(not (member$ ocio ?m)))
                  (lejos_de $?l&:(not (member$ ocio ?l)))
         )
   ?v <- (object (is-a Vivienda)
                  (cerca_de $?servicios_cercanos&:(hay-servicio-de-tipo ocio ?servicios_cercanos))
                  (ventajas-extra $?extras&:(not (member$ extra-ocio-cercano-soltero ?extras)))
         )
   =>
   (slot-insert$ ?v ventajas-extra 1 extra-ocio-cercano-soltero)
)

;Regla extra para solicitantes de tipo 'pareja_con_hijos'
;si no han especificado preferencia por zonaVerde a media distancia,
;se añade como ventaja extra si la vivienda está a media distancia de una.
(defrule asociar-heuristica-extra-zonaVerde-media-familia-declarativa
   (object (is-a Solicitante)
                  (tipo_solicitante pareja_con_hijos)
                  (cerca_de $?c&:(not (member$ zonaVerde ?c)))
                  (media_de $?m&:(not (member$ zonaVerde ?m)))
                  (lejos_de $?l&:(not (member$ zonaVerde ?l)))
         )
   ?v <- (object (is-a Vivienda)
                  (media_de $?servicios_medios&:(hay-servicio-de-tipo zonaVerde ?servicios_medios))
                  (ventajas-extra $?extras&:(not (member$ extra-zonaVerde-media-familia ?extras)))
         )
   =>
   (slot-insert$ ?v ventajas-extra 1 extra-zonaVerde-media-familia)
)

;; --- REGLAS DE CLASIFICACIÓN FINALES ---
;;se ejecutan con menor prioridad para asegurar que toda la asociación heurística ha terminado

;;Etiqueta: Parcialmente Adecuado
;;Condición: Falla en 2 o menos criterios
(defrule clasificar-parcialmente-adecuado
   (declare (salience -10))
   ?v <- (object (is-a Vivienda)
                  (etiqueta-recomendacion Sin-Clasificar)
                  (requisitos-fallados $?fallos&:(and (> (length$ ?fallos) 0)
                                                      (<= (length$ ?fallos) 2))))
   =>
   (send ?v put-etiqueta-recomendacion Parcialmente_Adecuado)
)

;; Etiqueta: Muy Recomendable
;; Condición: No falla en nada y tiene al menos una ventaja extra
(defrule clasificar-muy-recomendable
   (declare (salience -10))
   ?v <- (object (is-a Vivienda)
                  (etiqueta-recomendacion Sin-Clasificar)
                  (requisitos-fallados $?fallos&:(eq (length$ ?fallos) 0))
                  (ventajas-extra $?extras&:(> (length$ ?extras) 0)))
   =>
   (send ?v put-etiqueta-recomendacion Muy_Recomendable)
)

;; Etiqueta: Adecuado
;; Condición: No falla en nada y no tiene ventajas extra
(defrule clasificar-adecuado
   (declare (salience -10))
   ?v <- (object (is-a Vivienda)
                  (etiqueta-recomendacion Sin-Clasificar)
                  (requisitos-fallados $?fallos&:(eq (length$ ?fallos) 0))
                  (ventajas-extra $?extras&:(eq (length$ ?extras) 0)))
   =>
   (send ?v put-etiqueta-recomendacion Adecuado)
)


