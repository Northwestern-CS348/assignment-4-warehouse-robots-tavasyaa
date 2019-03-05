(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

	(:action robotMove
		:parameters (?l1 - location ?l2 - location ?r - robot)
		:precondition (and (at ?r ?l1) (free ?r) (connected ?l1 ?l2) (no-robot ?l2))
		:effect (and (at ?r ?l2) (not (at ?r ?l1)) (no-robot ?l1) (not (no-robot ?l2)))
	)

	(:action robotMoveWithPallette
		:parameters (?l1 - location ?l2 - location ?r - robot ?p - pallette)
		:precondition (and  (at ?p ?l1) (at ?r ?l1) (connected ?l1 ?l2) (free ?r) (no-robot ?l2) (no-pallette ?l2))
		:effect (and (at ?r ?l2) (not (at ?r ?l1)) (at ?p ?l2) (not (at ?p ?l1)) (no-robot ?l1) (not (no-robot ?l2)) (no-pallette ?l1) (not (no-pallette ?l2)))
	)

	(:action moveItemFromPalletteToShipment
		:parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
		:precondition (and (started ?s) (ships ?s ?o) (not (complete ?s)) (orders ?o ?si) (contains ?p ?si) (packing-location ?l) (at ?p ?l))
		:effect (includes ?s ?si)
	)

	(:action completeShipment
		:parameters (?l - location ?s - shipment ?o - order)
		:precondition (and (started ?s) (not (complete ?s))  (packing-at ?s ?l) (packing-location ?l))
		:effect (and (complete ?s) (available ?l) (not (packing-at ?s ?l)))
	)

)
