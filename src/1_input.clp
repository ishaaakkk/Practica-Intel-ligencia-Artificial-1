;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRACTICA SBC 
;; CLIPS 6.30
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1. MÓDULO DE ENTRADA (INPUT)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmodule INPUT
   (export ?ALL)

)
(deffunction ask-number (?question)
	(printout t ?question)
	(bind ?answer (read))
	(while (lexemep ?answer) do
		(printout t ?question)
		(bind ?answer (read))
		)
	(float ?answer)
)

(deffunction ask-int (?question)
	(printout t ?question)
	(bind ?answer (read))
	(while (lexemep ?answer) do
		(printout t ?question)
		(bind ?answer (read))
		)
	(integer ?answer))


(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer)
       then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer)
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes
       else no))

(deffunction pregunta-llista (?pregunta)
   (format t "%s " ?pregunta)
   (bind ?resposta (readline))
   (bind ?resultat (explode$ ?resposta))
   ?resultat
)

(deffunction calcDistanciaEuclidiana (?x1 ?y1 ?x2 ?y2)
   (sqrt (+ (* (- ?x2 ?x1) (- ?x2 ?x1))
            (* (- ?y2 ?y1) (- ?y2 ?y1)))))


;; Clase Solicitante
(defclass Solicitante
   (is-a USER)
   (role concrete)
   (pattern-match reactive)

   (slot id (type SYMBOL) (create-accessor read-write))
   (slot tipo_solicitante (type SYMBOL) (create-accessor read-write))
   

   (multislot cerca_de (type INSTANCE) (create-accessor read-write))
   (multislot media_de (type INSTANCE) (create-accessor read-write))
   (multislot lejos_de (type INSTANCE) (create-accessor read-write))

   (slot precioMax (type INTEGER) (create-accessor read-write))
   (slot edad (type INTEGER) (create-accessor read-write))
   (slot numHabitaciones (type INTEGER) (create-accessor read-write))
   (slot tipoVivienda (type SYMBOL) (create-accessor read-write))
   (slot coche (type SYMBOL) (create-accessor read-write))

   (slot ascensor (type SYMBOL) (create-accessor read-write))
   (slot mascotas (type SYMBOL) (create-accessor read-write))
   (slot amueblado (type SYMBOL) (create-accessor read-write))
   (slot piscina (type SYMBOL) (create-accessor read-write))
   (slot aire_acondicionado (type SYMBOL) (create-accessor read-write))
   (slot calefaccion (type SYMBOL) (create-accessor read-write))
   (slot garaje (type SYMBOL) (create-accessor read-write))
   (slot buenas_vistas (type SYMBOL) (create-accessor read-write))
   (slot terraza (type SYMBOL) (create-accessor read-write))
   (slot balcon (type SYMBOL) (create-accessor read-write))

   (slot altura-cat (type SYMBOL) (create-accessor read-write))
   (slot precio-cat (type SYMBOL) (create-accessor read-write))
   (slot tamano-cat (type SYMBOL) (create-accessor read-write))
   (slot edad-cat (type SYMBOL) (create-accessor read-write))

   (slot ascensor_Abs (type SYMBOL) (create-accessor read-write))
   (slot mascotas_Abs (type SYMBOL) (create-accessor read-write))
   (slot amueblado_Abs (type SYMBOL) (create-accessor read-write))
   (slot piscina_Abs (type SYMBOL) (create-accessor read-write))
   (slot aire_acondicionado_Abs (type SYMBOL) (create-accessor read-write))
   (slot calefaccion_Abs (type SYMBOL) (create-accessor read-write))
   (slot garaje_Abs (type SYMBOL) (create-accessor read-write))
   (slot buenas_vistas_Abs (type SYMBOL) (create-accessor read-write))
   (slot terraza_Abs (type SYMBOL) (create-accessor read-write))
   (slot balcon_Abs (type SYMBOL) (create-accessor read-write))

   (multislot restricciones)
   (multislot preferencias_pendientes (type SYMBOL) (create-accessor read-write))
)

;; Clase Vivienda
(defclass Vivienda
   (is-a USER)
   (role concrete)
   (pattern-match reactive)

   (slot id (type SYMBOL) (create-accessor read-write))
   
   (slot precio (type INTEGER) (create-accessor read-write))
   (slot habitaciones (type INTEGER) (create-accessor read-write))
   (slot superficie (type INTEGER) (create-accessor read-write))
   (slot ascensor (type SYMBOL) (create-accessor read-write))
   (slot mascotasPermitidas (type SYMBOL) (create-accessor read-write))
   (slot amueblado (type SYMBOL) (create-accessor read-write))
   (slot piscina (type SYMBOL) (create-accessor read-write))
   (slot aire_acondicionado (type SYMBOL) (create-accessor read-write))
   (slot calefaccion (type SYMBOL) (create-accessor read-write))
   (slot garaje (type SYMBOL) (create-accessor read-write))
   (slot buenas_vistas (type SYMBOL) (create-accessor read-write))
   (slot terraza (type SYMBOL) (create-accessor read-write))
   (slot balcon (type SYMBOL) (create-accessor read-write))
   
   (slot soleado (type SYMBOL) (create-accessor read-write))
   (slot fechaEdificacion (type INTEGER) (create-accessor read-write))
   
   (slot coordX (type INTEGER) (create-accessor read-write))
   (slot coordY (type INTEGER) (create-accessor read-write))

   (multislot cerca_de (type INSTANCE) (create-accessor read-write))
   (multislot media_de (type INSTANCE) (create-accessor read-write))
   (multislot lejos_de (type INSTANCE) (create-accessor read-write))

   (slot precio-cat (type SYMBOL) (create-accessor read-write))
   (slot tamano-cat (type SYMBOL) (create-accessor read-write))
   (slot superficie-cat (type SYMBOL) (create-accessor read-write))

   (slot ascensor_Abs (type SYMBOL) (create-accessor read-write))
   (slot mascotasPermitidas_Abs (type SYMBOL) (create-accessor read-write))
   (slot amueblado_Abs (type SYMBOL) (create-accessor read-write))
   (slot piscina_Abs (type SYMBOL) (create-accessor read-write))
   (slot aire_acondicionado_Abs (type SYMBOL) (create-accessor read-write))
   (slot calefaccion_Abs (type SYMBOL) (create-accessor read-write))
   (slot garaje_Abs (type SYMBOL) (create-accessor read-write))
   (slot buenas_vistas_Abs (type SYMBOL) (create-accessor read-write))
   (slot terraza_Abs (type SYMBOL) (create-accessor read-write))
   (slot balcon_Abs (type SYMBOL) (create-accessor read-write))
   
   (slot soleado_Abs (type SYMBOL) (create-accessor read-write))
   (slot fechaEdificacion_Abs (type SYMBOL) (create-accessor read-write))

   ;; Atributos para la asociación heurística
   (slot etiqueta-recomendacion (type SYMBOL) (default Sin-Clasificar) (create-accessor read-write))
   (multislot requisitos-fallados (type SYMBOL) (create-accessor read-write))
   (multislot ventajas-extra (type SYMBOL) (create-accessor read-write))
)
;; Subclase intermedia para tipos de vivienda en altura
(defclass ViviendaVertical
   (is-a Vivienda)
   (role concrete)
   (pattern-match reactive)
   (slot planta (type INTEGER) (create-accessor read-write))
   (slot planta_Abs (type SYMBOL) (create-accessor read-write))
   (slot atico (type SYMBOL) (create-accessor read-write))
)

;; Duplex
(defclass Duplex
   (is-a ViviendaVertical)
   (role concrete)
   (pattern-match reactive)
   (slot numPlantas (type INTEGER) (create-accessor read-write))
)

;; Clase Servicio
(defclass Servicio
   (is-a USER)
   (role concrete)
   (pattern-match reactive)

   (slot tipo (type SYMBOL) (create-accessor read-write))
   (slot coordX (type INTEGER) (create-accessor read-write))
   (slot coordY (type INTEGER) (create-accessor read-write))
)



;; Extraemos todos los tipos de servicios existentes
   (deffunction obtener-tipos-servicio ()
      (bind ?inst (find-all-instances ((?s Servicio)) TRUE))
      (bind ?tipos (create$))

      (foreach ?i ?inst
         (bind ?t (send ?i get-tipo))
         (if (not (member$ ?t ?tipos)) then
            (bind ?tipos (create$ ?tipos ?t))
         )
      )
      ?tipos
   ) 
   (deffunction preguntar-distancia-tipoServicio (?tipo)
      (format t "¿Como prefieres el servicio tipo " )
      (printout t ?tipo " (cerca media lejos): ")
      (bind ?resp (read))

      ;; Validación correcta usando member$
      (while (not (member$ ?resp (create$ cerca media lejos))) do
         (format t "Respuesta inválida. Indica cerca media o lejos: ")
         (bind ?resp (read))
      )

      ?resp
   )

   ;función auxiliar para comprobar si un servicio de un tipo dado está en una lista de instancias
   (deffunction hay-servicio-de-tipo (?tipo_buscado ?lista_servicios)
      (bind ?encontrado FALSE)
      (foreach ?servicio ?lista_servicios
         (if (eq (send ?servicio get-tipo) ?tipo_buscado) then
            (bind ?encontrado TRUE)
            (break)))
      ?encontrado
   )

   (defrule queEdad
      ?x <- (object (is-a Solicitante) (edad ?e&:(eq ?e 0)))
      =>
      (bind ?age (ask-int "Cual es tu edad? "))
      (send ?x put-edad ?age)
   )
   (defrule vehiculoPropio
      ?x <- (object (is-a Solicitante) (coche ?e&:(eq ?e 0)))
      =>
      (bind ?vehiculo (ask-int "Tienes vehiculo propio? "))
      (send ?x put-coche ?vehiculo)
   )
   
   (defrule preguntar-tipo-solicitante
      ?s <- (object (is-a Solicitante) (tipo_solicitante ?t&:(eq ?t nil)))
      =>
      (bind ?tipo (ask-question "¿Que tipo de solicitante eres? (estudiante, pareja_sin_hijos, pareja_con_hijos, movilidad_reducida, soltero): "
                                 estudiante pareja_sin_hijos pareja_con_hijos movilidad_reducida soltero))
      (send ?s put-tipo_solicitante ?tipo)
   )

   (defrule preguntar-tipo-vivienda
      ?s <- (object (is-a Solicitante) (tipoVivienda ?t&:(eq ?t nil)))
      =>
      (bind ?tipo (ask-question 
         "¿Que tipo de vivienda prefieres? (casa, piso): "
         casa piso))
      (send ?s put-tipoVivienda ?tipo)
   )

   ;; Preguntar altura solo si es Piso
   (defrule preguntar-altura-piso
      ?s <- (object (is-a Solicitante) 
                  (tipoVivienda piso)
                  (altura-cat ?a&:(eq ?a nil)))
      =>
      (bind ?altura (ask-question 
         "Si es un piso, ¿que altura prefieres? (baja, media, alta): "
         baja media alta))
      (send ?s put-altura-cat ?altura)
   )

   (defrule preguntar-precio-maximo
      ?s <- (object (is-a Solicitante) (precioMax ?p&:(eq ?p 0)))
      =>
      (bind ?precio (ask-int "Cual es tu presupuesto maximo? "))
      (send ?s put-precioMax ?precio)
   )

     (defrule preguntar-si-hay-restricciones
      ?u <- (object (is-a Solicitante) (id ?id))
      (not (pregunta-hecha restricciones-iniciales))
      =>
      (assert (pregunta-hecha restricciones-iniciales))
      (bind ?resp (yes-or-no-p "¿Tienes alguna restriccion? (yes/no) "))

      (if (eq ?resp yes)
         then
            (assert (debe-preguntar-restriccion ?id))
      )
   )

   (defrule preguntar-tipo-restriccion
      ?x <- (debe-preguntar-restriccion ?id)
      ?u <- (object (is-a Solicitante) (id ?id))
      =>
      (bind ?lista
         (pregunta-llista
            "Indica tus restricciones obligatorias separadas por espacios (habitaciones mascotas ascensor amueblado piscina aire_acondicionado calefaccion garaje buenas_vistas terraza balcon):"
         ))
      (send ?u put-restricciones ?lista)

      (retract ?x)
   )

   (defrule preguntar-restriccion-ascensor
      ?x <- (object (is-a Solicitante)
            (restricciones $?r&:(member ascensor ?r))
            (ascensor ?a&:(eq ?a nil)))
      =>
      (bind ?ans (yes-or-no-p "¿Necesitas ascensor? (yes/no): "))
      (send ?x put-ascensor ?ans)
   )

   (defrule preguntar-restriccion-amueblado
      ?x <- (object (is-a Solicitante)
            (restricciones $?r&:(member amueblado ?r))
            (amueblado ?a&:(eq ?a nil)))
      =>
      (bind ?ans (yes-or-no-p "¿Debe estar amueblado? (yes/no): "))
      (send ?x put-amueblado ?ans)
   )
   (defrule preguntar-restriccion-mascotas
      ?x <- (object (is-a Solicitante)
            (restricciones $?r&:(member mascotas ?r))
            (mascotas ?m&:(eq ?m nil)))
      =>
      (bind ?ans (yes-or-no-p "¿La vivienda tiene que aceptar masctoas? (yes/no): "))
      (send ?x put-mascotas ?ans)
   )

   (defrule preguntar-restriccion-habitaciones
      ?x <- (object (is-a Solicitante)
            (restricciones $?r&:(member habitaciones ?r))
            (numHabitaciones ?h&:(eq ?h 0)))
      =>
      (bind ?habs (ask-int "Cuantas habitaciones necesitas como minimo? "))
      (send ?x put-numHabitaciones ?habs)
   )

   (defrule preguntar-restriccion-piscina
      ?x <- (object (is-a Solicitante)
            (restricciones $?r&:(member piscina ?r))
            (piscina ?p&:(eq ?p nil)))
      =>
      (bind ?ans (yes-or-no-p "¿Necesitas que tenga piscina? (yes/no): "))
      (send ?x put-piscina ?ans)
   )

   (defrule preguntar-restriccion-aire_acondicionado
      ?x <- (object (is-a Solicitante)
            (restricciones $?r&:(member aire_acondicionado ?r))
            (aire_acondicionado ?a&:(eq ?a nil)))
      =>
      (bind ?ans (yes-or-no-p "¿Necesitas que tenga aire acondicionado? (yes/no): "))
      (send ?x put-aire_acondicionado ?ans)
   )

   (defrule preguntar-restriccion-calefaccion
      ?x <- (object (is-a Solicitante)
            (restricciones $?r&:(member calefaccion ?r))
            (calefaccion ?c&:(eq ?c nil)))
      =>
      (bind ?ans (yes-or-no-p "¿Necesitas que tenga calefacción? (yes/no): "))
      (send ?x put-calefaccion ?ans)
   )

   (defrule preguntar-restriccion-garaje
      ?x <- (object (is-a Solicitante)
            (restricciones $?r&:(member garaje ?r))
            (garaje ?g&:(eq ?g nil)))
      =>
      (bind ?ans (yes-or-no-p "¿Necesitas que tenga garaje? (yes/no): "))
      (send ?x put-garaje ?ans)
   )

   (defrule preguntar-restriccion-buenas_vistas
      ?x <- (object (is-a Solicitante)
            (restricciones $?r&:(member buenas_vistas ?r))
            (buenas_vistas ?v&:(eq ?v nil)))
      =>
      (bind ?ans (yes-or-no-p "¿Necesitas que tenga buenas vistas? (yes/no): "))
      (send ?x put-buenas_vistas ?ans)
   )

   (defrule preguntar-restriccion-terraza
      ?x <- (object (is-a Solicitante)
            (restricciones $?r&:(member terraza ?r))
            (terraza ?t&:(eq ?t nil)))
      =>
      (bind ?ans (yes-or-no-p "¿Necesitas que tenga terraza? (yes/no): "))
      (send ?x put-terraza ?ans)
   )

   (defrule preguntar-restriccion-balcon
      ?x <- (object (is-a Solicitante)
            (restricciones $?r&:(member balcon ?r))
            (balcon ?b&:(eq ?b nil)))
      =>
      (bind ?ans (yes-or-no-p "¿Necesitas que tenga balcón? (yes/no): "))
      (send ?x put-balcon ?ans)
   )

   (defrule preguntar-si-hay-preferencias-servicios
      ?u <- (object (is-a Solicitante) (id ?id))
      (not (pregunta-hecha preferencias-servicios))
      =>
      (assert (pregunta-hecha preferencias-servicios))
      (bind ?resp (yes-or-no-p "¿Tienes alguna preferencia sobre la cercania de servicios? (yes/no) "))
      (if (eq ?resp yes) then
         (assert (debe-preguntar-preferencias-servicios ?id))
      )
   )

   (defrule preguntar-que-preferencias-servicios
      ?f <- (debe-preguntar-preferencias-servicios ?id)
      ?u <- (object (is-a Solicitante) (id ?id))
      =>
      (retract ?f)
      (bind ?tipos_disponibles (obtener-tipos-servicio))
      (printout t "Servicios disponibles: " (implode$ ?tipos_disponibles) crlf)
      (bind ?lista_prefs (pregunta-llista "Indica los servicios sobre los que tienes preferencias, separados por espacios: "))      
      (send ?u put-preferencias_pendientes ?lista_prefs)
   )

   (defrule preguntar-distancia-para-preferencias-seleccionadas
      ?u <- (object (is-a Solicitante)
                  (preferencias_pendientes ?tipo_pref $?resto_prefs) 
                  (cerca_de $?c) (media_de $?m) (lejos_de $?l))
      =>
      (bind ?pref_dist (preguntar-distancia-tipoServicio ?tipo_pref))
      (switch ?pref_dist
         (case cerca then (send ?u put-cerca_de (create$ ?c ?tipo_pref))) ;; se crea una nueva lista usando la antigua y añadiendo el nuevo
         (case media then (send ?u put-media_de (create$ ?m ?tipo_pref)))
         (case lejos then (send ?u put-lejos_de (create$ ?l ?tipo_pref)))
      )
      (send ?u put-preferencias_pendientes ?resto_prefs) ;se elimina el procesado de la lista de pendientes
   )


